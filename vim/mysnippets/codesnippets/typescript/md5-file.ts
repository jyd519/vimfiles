import fsStatic = require("fs");
import crypto = require('crypto');

let fs: typeof fsStatic;
if (process.versions.electron) {
  fs = require('original-fs');
} else {
  fs = require('fs');
}

// fileMd5: md5 for files and their options
export function fileMd5(path: string): Promise<string> {
  let resolved = false;
  return new Promise<string>((resolve, reject) => {
    if (!(fs.lstatSync(path).isDirectory())) {
      const stream = fs.createReadStream(path);
      const hash = crypto.createHash('md5');

      stream.on('error', function(err){
        if (!resolved) {
          reject(err);
          resolved = true;
        }
      });

      stream.on('data', function (data) {
        hash.update(data);
      });

      stream.on('close', function () {
        if (!resolved) {
          resolved = true;
          resolve(hash.digest('hex'));
        }
      });
    } else {
      reject(new Error(path + "  - Is a directory"));
    }
  });
}
