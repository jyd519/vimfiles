export function getArg(name: string): string {
  for (let i = 0, argv = process.argv; i < argv.length; ++i) {
    if (argv[i].startsWith('-' + name)) {
      if (argv[i] === '-' + name) {
        return argv[i + 1];
      }
      if (argv[i].startsWith('-' + name + '=')) {
        return argv[i].substr(argv[i].indexOf('=') + 1);
      }
    }
  }
}
