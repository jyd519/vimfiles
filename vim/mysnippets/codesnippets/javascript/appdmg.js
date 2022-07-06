gulp.task('client-dmg', function() {
  const appdmg = require('gulp-appdmg');
  return gulp.src([])
    .pipe(appdmg({
      target: './dist/client-darwin.dmg',
      basepath: __dirname,
      specification: {
        title: "悦考考试机",
        icon: "./dist/shell-darwin/joytest.app/Contents/Resources/app.icns",
        format: "UDBZ",
        contents: [
          { "x": 448, "y": 344, "type": "link", "path": "/Applications" },
          { "x": 192, "y": 344, "type": "file", "path": "./dist/shell-darwin/joytest.app" }
        ],
      }
    }));
});
