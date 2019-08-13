#!/usr/bin/env python

import time
import os

# return the filename in the path without extension
def findFileName(path, ext):
    name = ''
    for projFile in os.listdir(path):
        # cocoapods will generate _Pods.xcodeproj as well
        if projFile.endswith(ext) and not projFile.startswith('_Pods'):
            name = projFile[:-len(ext):]
    return name

# WARNING!! No / in the end
def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))

def findProjectName(working_directory):
    projectName = findFileName(working_directory, '.xcodeproj')

    if len(projectName) <= 0:
        # cocoapod projects
        projectName = findFileName(working_directory, '.podspec')
    return projectName

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
    '-Wall',        # Enable all warnings
    '-Wextra',      # Enable extra warnings
    '-Wno-unused-parameter',
    '-fobjc-arc',
    '-fobjc-exceptions',
    '-fexceptions',
    '-arch', 'arm64',
    '-D__IPHONE_OS_VERSION_MIN_REQUIRED=90000',
    '-fobjc-runtime=ios-9.0.0',
    '-fencode-extended-block-signature',
    '-DNDEBUG',
    '-x', 'objective-c',
    '-isystem', '/usr/include',
    '-isystem', '/usr/local/include',
    '-isystem', '/Library/Developer/CommandLineTools/usr/include/c++/v1',
    '-I',
    '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
    '-isysroot',
    '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk',
    '-F', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks',
    '-I', '.'
]

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = ''

# if os.path.exists( compilation_database_folder ):
# database = ycm_core.CompilationDatabase( compilation_database_folder )
# else:
# we don't use compilation database
database = None

SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']


def Subdirectories(directory):
    res = []
    for path, subdirs, files in os.walk(directory):
        for name in subdirs:
            item = os.path.join(path, name)
            res.append(item)
    return res


def sorted_ls(path):
    mtime = lambda f: os.stat(os.path.join(path, f)).st_mtime
    return list(sorted(os.listdir(path), key=mtime))

def IncludeClangInXCToolChain(flags, working_directory):
    if not working_directory:
        return list(flags)

    new_flags = list(flags)
    path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/'
    clangPath = sorted_ls(path)[::-1]  # newest file first

    includePath = ''
    if (len(clangPath) > 0):
        includePath = os.path.join('', *[path, clangPath[0], 'include'])
        new_flags.append('-I'+includePath)
    return new_flags


def FindDerivedDataPath(derivedDataPath, projectName):
    simulatorPaths = ['Build/Intermediates/CodeCoverage/Products/Debug-iphonesimulator/',  # if you enable CodeCoverage, the framework of test target will be put in coverage folder, strange
                      'Build/Intermediates/CodeCoverage/Products/Debug-iphoneos/',
                      'Build/Products/Debug-iphonesimulator/',
                      'Build/Products/Debug-iphoneos/']

    # search ~/Library/Developer/Xcode/DerivedData/ to find <project_name>-dliwlpgcvwijijcdxarawwtrfuuh
    derivedPath = sorted_ls(derivedDataPath)[::-1]  # newest file first
    for productPath in derivedPath:
        if productPath.lower().startswith(projectName.lower()):
            for simulatorPath in simulatorPaths:
                projectPath = os.path.join(
                    '', *[derivedDataPath, productPath, simulatorPath])
                if (len(projectPath) > 0) and os.path.exists(projectPath):
                    # the lastest product is what we want (really?)
                    return projectPath
    return ''


def IncludeFlagsOfFrameworkHeaders(theFlags, working_directory):

    path_flag = '-ProductFrameworkInclude'

    # if user doesn't want to include the third-party frameworks
    if not path_flag in theFlags:
        return theFlags

    # remove the path_flag
    flags = theFlags
    flags.remove(path_flag)

    if not working_directory:
        return flags

    derivedDataPath = os.path.expanduser(
        '~/Library/Developer/Xcode/DerivedData/')

    # find the project name
    projectName = findProjectName(working_directory)
    if len(projectName) <= 0:
        return flags

    # find the derived data path
    projectPath = FindDerivedDataPath(derivedDataPath, projectName)
    if (len(projectPath) <= 0) or not os.path.exists(projectPath):
        return flags

    new_flags = flags

    # add all frameworks in the /Build/Products/Debug-iphonesimulator/xxx/xxx.framework

    # iterate through all frameworks folders /Debug-iphonesimulator/xxx/xxx.framework
    for frameworkFolder in os.listdir(projectPath):
        frameworkPath = os.path.join('', projectPath, frameworkFolder)

        if not os.path.isdir(frameworkPath):
            continue

        once = False
        # the framework name might be different than folder name
        # we need to iterate all frameworks
        for frameworkFile in os.listdir(frameworkPath):
            if frameworkFile.endswith('framework'):

                # only add framework folder which actually contains frameworks
                if not once:
                    # framwork folder '-F/Debug-iphonesimulator/<framework-name>'
                    # solve <Kiwi/KiwiConfigurations.h> not found problem

                    new_flags.append('-F'+frameworkPath)
                    once = True
                # include headers '-I/Debug-iphonesimulator/xxx/yyy.framework/Headers'
                # allow you to use #import "Kiwi.h". NOT REQUIRED, but I am too lazy to change existing codes
                new_flags.append(
                    '-I' + os.path.join('', frameworkPath, frameworkFile, 'Headers'))

    return new_flags


def IncludeFlagsOfSubdirectory(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_include_subdir = False
    path_flags = ['-ISUB']
    for flag in flags:
        # include the directory of flag as well
        new_flag = [flag.replace('-ISUB', '-I')]

        if make_next_include_subdir:
            make_next_include_subdir = False
            for subdir in Subdirectories(os.path.join(working_directory, flag)):
                new_flag.append('-I')
                new_flag.append(subdir)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_include_subdir = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                for subdir in Subdirectories(os.path.join(working_directory, path)):
                    new_flag.append('-I' + subdir)
                break

        new_flags = new_flags + new_flag
    return new_flags


def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    # add include subfolders as well
    flags = IncludeFlagsOfSubdirectory(flags, working_directory)

    # include framework header in derivedData/.../Products
    flags = IncludeFlagsOfFrameworkHeaders(flags, working_directory)

    # include libclang header in xctoolchain
    flags = IncludeClangInXCToolChain(flags, working_directory)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']


def GetCompilationInfoForFile(filename):
    # The compilation_commands.json file generated by CMake does not have entries
    # for header files. So we do our best by asking the db for flags for a
    # corresponding source file, if any. If one exists, the flags for that file
    # should be good enough.
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(
                    replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)


def FlagsForFile(filename, **kwargs):
    if database:
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object
        compilation_info = GetCompilationInfoForFile(filename)
        if not compilation_info:
            return None

        final_flags = MakeRelativePathsInFlagsAbsolute(
            compilation_info.compiler_flags_,
            compilation_info.compiler_working_dir_)

        # NOTE: This is just for YouCompleteMe; it's highly likely that your project
        # does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
        # ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
        # try:
        # final_flags.remove( '-stdlib=libc++' )
        # except ValueError:
        # pass
    else:
        relative_to = DirectoryOfThisScript()
        final_flags = MakeRelativePathsInFlagsAbsolute(flags, relative_to)

    # update .clang for chromatica every 5min TODO: very dirty
    chromatica_file = DirectoryOfThisScript() + '/.clang'

    if (not os.path.exists(chromatica_file)) or (time.time() - os.stat(chromatica_file).st_mtime > 5*60):
        parsed_flags = IncludeFlagsOfSubdirectory(
            final_flags, DirectoryOfThisScript())
        # chromatica doesn't handle space in flag
        escaped = [flag for flag in parsed_flags if " " not in flag]
        f = open(chromatica_file, 'w')  # truncate the current file
        f.write('flags='+' '.join(escaped))
        f.close()

    return {
        'flags': final_flags,
        'do_cache': True
    }
