#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# モジュールの読込
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp      = require 'gulp'
watch     = require 'gulp-watch'
plumber   = require 'gulp-plumber'
notify    = require 'gulp-notify'
webserver = require 'gulp-webserver'
sequence  = require 'run-sequence'
rename    = require 'gulp-rename'
gzip      = require 'gulp-gzip'
del       = require 'del'

compass   = require 'gulp-compass'
concatCss = require 'gulp-concat-css'
minifyCSS = require 'gulp-minify-css'

coffee    = require 'gulp-coffee'
uglify    = require 'gulp-uglify'
concatJs  = require 'gulp-concat'

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# 設定
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
options =
    'dest':
        'css':   'assets/css'
        'js':    'assets/js'
        'image': 'assets/img'
    'build':
        'css': 'build/css'
        'js':  'build/js'
    'src':
        'vendor': 'src/vendor'
        'scss':   'src/scss'
        'coffee': 'src/coffee'

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] CSSのタスク全般を処理
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'css', ->
    sequence(
        'css:vendor'
        'css:compass'
        'css:build'
        'css:archive'
    )

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][css] ベンダーディレクトリから必要なCSSを収集する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'css:vendor', ['css:clean'], ->

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][css] scssをcompassでビルド
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'css:compass', ->
    gulp.src options.src.scss + '/**/*.scss'
        .pipe plumber
            errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe compass
            style: 'nested'
            relative: true
            css:  options.build.css
            sass: options.src.scss
            javascript: options.build.js
            generated_images_path: options.dest.image


#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][css] cssを結合・最小化する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'css:build', ->
    gulp.src options.build.css + '/**/*.css'
        .pipe plumber
            errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe concatCss 'main.css'
        .pipe gulp.dest options.dest.css
        .pipe rename extname: '.min.css'
        .pipe minifyCSS()
        .pipe gulp.dest options.dest.css

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][css] cssを圧縮する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'css:archive', ->
    gulp.src options.dest.css + '/**/*.css'
        .pipe plumber
            errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe gulp.dest options.dest.css
        .pipe rename extname: '.css.gz'
        .pipe gzip append: false
        .pipe gulp.dest options.dest.css

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][css] CSSのビルドファイルをクリアする
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'css:clean', ->
    del [
        options.build.css + '/**/*'
        options.dest.css + '/main.*'
    ]

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] JavaScriptのタスク全般を処理
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'js', ->
    sequence(
        'js:vendor'
        'js:coffee'
        'js:build'
        'js:archive'
    )

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][js] ベンダーディレクトリから必要なJavaScriptを収集する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'js:vendor', ['js:clean'], ->
    gulp.src options.src.vendor + '/jquery/dist/jquery.min.js'
        .pipe rename prefix: '0-'
        .pipe gulp.dest options.build.js
    gulp.src options.src.vendor + '/respond-minmax/dest/respond.min.js'
        .pipe gulp.dest options.dest.js

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][js] coffeescriptをビルド
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'js:coffee', ->
    gulp.src options.src.coffee + '/**/*.coffee'
        .pipe plumber
            errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe coffee()
        .pipe gulp.dest options.build.js

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][js] javascriptを結合・最小化する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'js:build', ->
    gulp.src options.build.js + '/**/*.js'
        .pipe plumber
            errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe concatJs 'main.js'
        .pipe gulp.dest options.dest.js
        .pipe rename extname: '.min.js'
        .pipe uglify()
        .pipe gulp.dest options.dest.js

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][js] javascriptを圧縮する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'js:archive', ->
    gulp.src options.dest.js + '/**/*.js'
        .pipe plumber
            errorHandler: notify.onError "Error: <%= error.message %>"
        .pipe gulp.dest options.dest.js
        .pipe rename extname: '.js.gz'
        .pipe gzip append: false
        .pipe gulp.dest options.dest.js

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク][js] Javascriptのビルドファイルをクリアする
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'js:clean', ->
    del [
        options.build.js + '/**/*'
        options.dest.js + '/main.*'
        options.dest.js + '/respond.min.*'
    ]

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] watch処理を行う
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'watch', ->
    gulp.watch options.src.scss   + '/*.scss', ['css']
    gulp.watch options.src.coffee + '/*.coffee', ['js']

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] ローカルサーバを準備する
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'server', ->
    gulp.src('./')
        .pipe webserver
            fallback: 'index.html'
            directoryListing: true
            livereload: true

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] ビルドタスク
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'build', ['css', 'js']

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] クリーンタスク
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'clean', ['css:clean', 'js:clean']

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
# [タスク] デフォルトタスク
#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
gulp.task 'default', ['server', 'watch']
