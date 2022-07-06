const path = require('path');
const fs = require('fs');

const files = {};
fs.readdirSync(".")
  .filter(p => p.endsWith(".ts"))
  .map((p) => files[path.basename(p, '.ts')] = "./" + p);

module.exports = {
  entry: files,
  devtool: 'inline-source-map',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: [ '.tsx', '.ts', '.js' ]
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'dist')
  }
};
