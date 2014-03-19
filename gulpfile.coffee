gulp = require('gulp')
gutil = require('gulp-util')
jade = require('gulp-jade')
coffee = require('gulp-coffee')
clean = require('gulp-clean')
connect = require('gulp-connect')
stylus = require('gulp-stylus')
bower = require('gulp-bower')
mocha = require('gulp-mocha')

gulp.task 'coffee', ->
  gulp.src('src/*.coffee')
      .pipe(coffee())
      .pipe gulp.dest('lib')

gulp.task 'templates', ->
  gulp.src('src/*.jade')
      .pipe(jade({pretty:true}))
      .pipe gulp.dest('.')
  gulp.src('src/*.styl')
      .pipe(stylus({use:['nib']}))
      .pipe gulp.dest('.')

gulp.task 'connect', connect.server(
  root: [__dirname]
  port: 1337
  livereload: true
  open:
    browser: 'Google Chrome'
  )

gulp.task 'bower', ->
  bower().pipe gulp.dest('lib/')

gulp.task 'test', ['coffee'], ->
   gulp.src ['lib/nicolayer.js', 'test/*.coffee']
     .pipe mocha {reporter: 'spec'}

gulp.task 'clean', ->
  gulp.src('./*.html')
      .pipe(clean())
  gulp.src('./*.css')
      .pipe(clean())
  gulp.src('lib')
      .pipe(clean())

gulp.task 'default', ['coffee', 'templates', 'connect']
