gulp = require('gulp')
gutil = require('gulp-util')
jade = require('gulp-jade')
coffee = require('gulp-coffee')
del = require('del')
server = require('gulp-webserver')
stylus = require('gulp-stylus')
uglify = require('gulp-uglify')
rename = require('gulp-rename')
bower = require('gulp-bower')
mocha = require('gulp-mocha')
pkg = require('./package.json')
nib = require('nib')
runSequence = require('run-sequence')

gulp.task 'coffee', ->
  gulp.src('src/*.coffee')
      .pipe(coffee())
      .pipe gulp.dest('lib')

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
  
gulp.task 'bower', ->
  bower().pipe gulp.dest('lib/')

gulp.task 'test', ['coffee'], ->
   gulp.src ["lib/#{pkg.name}.js", 'test/*.coffee']
     .pipe mocha {reporter: 'spec'}

gulp.task 'compress', ->
  gulp.src("lib/#{pkg.name}.js")
    .pipe(rename("#{pkg.name}.min.js"))
    .pipe(uglify())
    .pipe(gulp.dest('lib/'))

gulp.task 'clean', ->
  gulp.src('./*.html')
      .pipe(clean())
  gulp.src('./*.css')
      .pipe(clean())
  gulp.src('lib')
      .pipe(clean())

gulp.task 'default', (cb) ->
  runSequence(['coffee', 'templates'], 'connect', cb)

gulp.task 'release', ['coffee', 'compress']
