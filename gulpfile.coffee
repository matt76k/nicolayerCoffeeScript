gulp        = require('gulp')
gutil       = require('gulp-util')
jade        = require('gulp-jade')
coffee      = require('gulp-coffee')
del         = require('del')
server      = require('gulp-webserver')
stylus      = require('gulp-stylus')
uglify      = require('gulp-uglify')
rename      = require('gulp-rename')
mocha       = require('gulp-mocha')
pkg         = require('./package.json')
nib         = require('nib')
runSequence = require('run-sequence')

browserify  = require('browserify')
source      = require('vinyl-source-stream')

gulp.task 'coffee', ->
 browserify
    entries: ['./src/main.coffee']
    extensions: ['.coffee']
  .transform 'coffeeify'
  .bundle()
  .pipe source 'main.js'
  .pipe gulp.dest './'

gulp.task 'templates', ->
  gulp.src('src/*.jade')
      .pipe(jade({pretty:true}))
      .pipe gulp.dest('.')
  gulp.src('src/*.styl')
      .pipe(stylus({use:[nib()]}))
      .pipe gulp.dest('.')

gulp.task 'connect', ->
  gulp.src('.')
      .pipe server({
        open: true,
        port: 8888,
        livereload: true
      })
  
gulp.task 'test', ['coffee'], ->
   gulp.src ["lib/#{pkg.name}.js", 'test/*.coffee']
     .pipe mocha {reporter: 'spec'}

gulp.task 'compress', ->
  browserify
      extries: ['./src/nicolayer.coffee']
      extensions: ['.coffee']
    .transform 'coffeeify'
    .bundle()
    .pipe source 'nicolayer.js'
    #.pipe rename("#{pkg.name}.min.js")
    #.pipe uglify()
    .pipe gulp.dest './dist'

gulp.task 'clean', ->
  del ['*.html', '*.css', '*.js', 'dist']

gulp.task 'default', (cb) ->
  runSequence(['coffee', 'templates'], 'connect', cb)

gulp.task 'release', ['coffee', 'compress']
