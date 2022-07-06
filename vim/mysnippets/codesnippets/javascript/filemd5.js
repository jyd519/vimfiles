function fileMd5(path) {
  let resolved = false;
  return new Promise((resolve, reject) => {
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
