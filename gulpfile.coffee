gulp = require 'gulp'
gutil = require 'gutil'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
slim = require 'gulp-slim'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
coffeeify = require 'coffeeify'
watchify = require 'watchify'
jasmine = require 'gulp-jasmine'

gulp.task 'watchify', ->
  bundler = watchify browserify './app/clientApp.coffee', {
    basedir: __dirname
    paths: ['./app', './app/client']
    cache: {} # required for watchify
    packageCache: {} # required for watchify
    fullPaths: true # required to be true only for watchify
  }
  bundler.transform('coffeeify')
  bundle = ->
    localTime = new Date()
    localTime.setMinutes(localTime.getMinutes() - localTime.getTimezoneOffset())
    console.log localTime.toISOString().slice(11, -5) + "  -- Browserifying"
    bundler.bundle()
      .on 'error', gutil.log.bind(gutil, 'Browserify Error')
      .pipe source('app.js')
      .pipe buffer()
      .pipe gulp.dest 'public'
      # .pipe uglify()
      .pipe rename(suffix: '.min')
      .pipe gulp.dest 'public'
  bundler.on('update', bundle)
  bundle()

gulp.task 'browserify', ->
  b = browserify(
    basedir: __dirname
    paths: ['./app', './app/client']
    cache: {}
    packageCache: {}
    fullPaths: true
  )
  b.transform(coffeeify)
  b.add('./app/clientApp.coffee')
  b.bundle()
    .pipe source('app.js')
    .pipe gulp.dest 'public'

gulp.task 'assets', ->
  gulp.src 'assets/images/**/*'
  .pipe gulp.dest 'public/assets/images'
  gulp.src 'assets/fonts/**/*'
  .pipe gulp.dest 'public/assets/fonts'

gulp.task 'sass', ->
  gulp.src 'assets/stylesheets/styles.sass'
  .pipe sass(
    indentedSyntax: true
    outputStyle: 'nested'
  )
  .pipe gulp.dest 'public/assets/stylesheets'
  gulp.src 'assets/stylesheets/styles.sass'
  .pipe sass(
    indentedSyntax: true
    outputStyle: 'compressed'
  )
  .pipe rename({suffix: '.min'})
  .pipe gulp.dest 'public/assets/stylesheets'

gulp.task 'jasmine', ->
  gulp.src 'spec/**/*.coffee'
    .pipe jasmine()

gulp.task 'test', ->
  gulp.src 'spec/**/*.coffee'
    .pipe jasmine()
  gulp.watch 'app/**/*.coffee', ['jasmine']
  gulp.watch 'spec/**/*.coffee', ['jasmine']

# Add a watcher to change any files
gulp.task 'watch', ->
  gulp.watch 'assets/**/*.sass', ['sass']

# Default task will call all tasks created so far
gulp.task 'default', ['watchify', 'assets', 'sass', 'watch']
gulp.task 'deploy', ['browserify', 'assets', 'sass']
