const crypto = require("crypto");
const fs = require("fs");

function encrypt(text, password) {
  const iv = Buffer.from(crypto.randomBytes(16));
  const key = crypto.pbkdf2Sync(password, iv, 10000, 32, "sha256");
  const encryptor = crypto.createCipheriv("AES-256-CBC", key, iv);
  let cipher = encryptor.update(text, "utf8", "base64");
  cipher += encryptor.final("base64");
  return cipher + "$" + iv.toString("base64");
}

function decrypt(blob, password) {
  const [cipher_text, ivs] = blob.split("$");
  const iv = Buffer.from(ivs, "base64");
  const key = crypto.pbkdf2Sync(password, iv, 10000, 32, "sha256");
  const encryptor = crypto.createDecipheriv("AES-256-CBC", key, iv);
  let plain = encryptor.update(cipher_text, "base64", "utf8");
  plain += encryptor.final("utf8");
  return plain;
}

// wrap long string with width of 80
function wrapText(text, width) {
  var lines = ["-----BEGIN VIM ENCRYPTED-----"];
  for (let i = 0; i < text.length; i += width) {
    lines.push(text.substring(i, i + width));
  }
  lines.push("-----END VIM ENCRYPTED-----");
  return lines.join("\n");
}

// join string
function joinText(text) {
  text = text.replace(/\r/g, "");
  text = text.trim();
  var lines = text.split("\n");
  if (lines.length >= 2) {
    return lines.slice(1, lines.length - 1).join("");
  }
  return lines.join("");
}

function main() {
  var password = "JYD";
  var decryptText = false;
  for (let i = 0; i < process.argv.length; i++) {
    if (process.argv[i] == "-d") {
      decryptText = true;
    }
    if (process.argv[i] == "-p") {
      password = process.argv[i + 1];
      i++;
    }
  }

  var stdinBuffer = fs.readFileSync(0); // STDIN_FILENO = 0
  const input = stdinBuffer.toString();

  if (decryptText) {
    try {
      process.stdout.write(decrypt(joinText(input), password));
    } catch (e) {
      process.stderr.write("Error: " + e);
      process.exit(-1);
    }
  } else {
    const cipher = encrypt(input, password);
    process.stdout.write(wrapText(cipher, 50));
  }
}

main();
