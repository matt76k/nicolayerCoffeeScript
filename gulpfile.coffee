gulp = require('gulp')
gutil = require('gulp-util')
jade = require('gulp-jade')
coffee = require('gulp-coffee')
clean = require('gulp-clean')
connect = require('gulp-connect')
bower = require('gulp-bower')

gulp.task 'coffee', ->
  gulp.src('src/*.coffee')
      .pipe(coffee())
      .pipe gulp.dest('lib')

gulp.task 'templates', ->
  gulp.src('src/*.jade')
      .pipe(jade({pretty:true}))
      .pipe gulp.dest('.')

gulp.task 'connect', connect.server(
  root: __dirname
  port: 1337
  livereload: true
  open:
    browser: 'Google Chrome'
  )

gulp.task 'bower', ->
  bower().pipe gulp.dest('lib/')

gulp.task 'clean', ->
  gulp.src('./*.html')
      .pipe(clean())
  gulp.src('lib')
      .pipe(clean())

gulp.task 'default', ['coffee', 'templates', 'connect']
