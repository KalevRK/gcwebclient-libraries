gulp   = require "gulp"
del    = require "del"

cleanPaths = [
  "dist/**/.bower.json"
  "dist/**/package.json"
  "dist/**/composer.json"
  "dist/**/*.md"
  "dist/**/grunt.js"
  "dist/**/*.pdf"
  "dist/**/.editorconfig"
  "dist/**/*.ai"
  "dist/**/*.eps"
  "dist/**/*.png"
  "dist/**/*.svg"
  "dist/**/media/"
  "dist/**/.travis*"
  "dist/**/*.markdown"
  "dist/**/LICENSE.txt"
  "dist/**/CHANGELOG.txt"
  "dist/**/*LICENSE.txt"
  "dist/**/LICENSE"
  "dist/**/src/"
  "dist/**/test/"
]

gulp.task "clean", (cb)->
  del cleanPaths, cb

gulp.task "default", ["build"]
