from __future__ import with_statement
import os, sys
import shutil
import errno
import urllib2
import zipfile
import subprocess
import glob
import json
import hashlib

from fabric import colors
from fabric.api import cd, sudo, run, lcd, local, put, env, task, settings
from fabric.contrib import files
from fabric.contrib.console import confirm
from fabric.operations import _prefix_commands, _prefix_env_vars, require

import utils

script_path = os.path.dirname(os.path.realpath(__file__))
root_path = os.path.dirname(script_path)

# default environments
env.colorize_errors = True
env.remote_dir='/var/ata/update-server'
env.shell='/bin/bash --noprofile -c'
env.use_ssh_config=True
env.sv_confd='/etc/supervisor/conf.d/'

STAGES = {
    'test': {
        'hosts': ['root@172.16.18.211'],
    },
    'production': {
        'hosts': ['joy-web1', 'joy-web2'],
    },
}

def stage_set(stage_name='test'):
    env.stage = stage_name
    for option, value in STAGES[env.stage].items():
        setattr(env, option, value)


def mkdirs(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass

def rm_rf(path):
  try:
      if os.path.exists(path):
        shutil.rmtree(path, ignore_errors=True)
  except OSError as e:
    if e.errno != errno.ENOENT:
      raise


def shell_run(command):
    p = subprocess.Popen(command, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,shell=True)
    out, err = p.communicate()
    retcode = p.poll()
    if retcode != 0:
        print "[ERROR] ", p.returncode, ' cmd: ', command
        print err
        return []

    return out.split('\n')


def download_file(url, target):
    f = urllib2.urlopen(url)
    with open(target, "wb") as code:
        code.write(f.read())

def unzip_file(zipf, target):
    subprocess.check_call(['7z', 'x', '-o'+target, zipf])

def zipdir(path, zipf):
    subprocess.check_call(['7z', 'a', zipf, '.', '-xr!.DS_Store'], cwd=path)

def _ignorepath(path, names):
    if path.endswith('build'):
        return ['tools']
    return []   # nothing will be ignored


def recursive_overwrite(src, dest, ignore=None):
    if not os.path.exists(src):
        return
    if os.path.isdir(src):
        if not os.path.isdir(dest):
            os.makedirs(dest)
        files = os.listdir(src)
        if ignore is not None:
            ignored = ignore(src, files)
        else:
            ignored = set()
        for f in files:
            if f not in ignored:
                recursive_overwrite(os.path.join(src, f),
                                    os.path.join(dest, f),
                                    ignore)
    else:
        shutil.copy(src, dest)

def copy2(src, dest_dir):
    for f in glob.glob(src):
        shutil.copy(f, dest_dir)


def calc_file_md5(filename):
    with open(filename, 'rb') as f:
        m = hashlib.md5()
        while True:
            data = f.read(128*m.block_size)
            if not data:
                break
            m.update(data)
        return m.hexdigest()

@task
def production():
    stage_set('production')

@task
def test():
    stage_set('test')

@task
def build():
    subprocess.check_call(['make'], cwd=root_path);


@task
def deploy():
    require('stage', provided_by=(test,production,))

    if not utils.user_exists('joyupdater'):
      utils.user_create('joyupdater')

    if not files.exists(env.remote_dir):
        sudo("mkdir -p {}".format(env.remote_dir))
        sudo("chown -R joyupdater:joyupdater {}".format(env.remote_dir))

    with lcd(root_path), cd(env.remote_dir):
        if not files.exists(os.path.join(env.sv_confd, 'update-server.conf')):
          put('scripts/update-server.conf', env.sv_confd)
          run('supervisorctl reload')

        # upload files
        run('mkdir -p {}/updates'.format(env.remote_dir))
        if os.path.exists('templates'):
          run('mkdir -p {}/templates'.format(env.remote_dir))
          put('templates/*.*', '{}/templates'.format(env.remote_dir))

        put('update-server', env.remote_dir)

        local_cnf = os.path.join(root_path, 'config.{}.toml'.format(env.stage))
        if os.path.exists(local_cnf):
          put(local_cnf, env.remote_dir+'/config.toml')

        if not files.exists('{}/config.toml'.format(env.remote_dir)):
          put('*.toml.example', env.remote_dir)
          run('mv config.toml.example config.toml')

        sudo("chown -R joyupdater:joyupdater {}".format(env.remote_dir))
        sudo("chmod a+x {}/update-server".format(env.remote_dir))

        # restart server
        run('supervisorctl restart updateserver')
        print colors.green("app deployed")


# vim:set et sw=4 ts=4 tw=80
