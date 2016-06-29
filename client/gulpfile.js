'use strict';

// Include promise polyfill for node 0.10 compatibility
require('es6-promise').polyfill();

// Include Gulp & tools we'll use
var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var del = require('del');
var runSequence = require('run-sequence');
var browserSync = require('browser-sync');
var reload = browserSync.reload;
var merge = require('merge-stream');
var path = require('path');
var fs = require('fs');
var glob = require('glob-all');
var historyApiFallback = require('connect-history-api-fallback');
var packageJson = require('./package.json');
var crypto = require('crypto');

var DIST = 'dist';

var AUTOPREFIXER_BROWSERS = [
    'ie >= 10',
    'ie_mob >= 10',
    'ff >= 30',
    'chrome >= 34',
    'safari >= 7',
    'opera >= 23',
    'ios >= 7',
    'android >= 4.4',
    'bb >= 10'
];

var dist = function(subpath) {
    return !subpath ? DIST : path.join(DIST, subpath);
};

var styleTask = function(stylesPath, srcs) {
    return gulp.src(srcs.map(function(src) {
        return path.join('app', stylesPath, src);
    }))
    .pipe($.changed(stylesPath, {extension: '.css'}))
    .pipe($.autoprefixer(AUTOPREFIXER_BROWSERS))
    .pipe(gulp.dest('.tmp/' + stylesPath))
    .pipe($.minifyCss())
    .pipe(gulp.dest(dist(stylesPath)))
    .pipe($.size({title: stylesPath}));
};

// Compile and automatically prefix stylesheets
gulp.task('styles', function() {
    return styleTask('styles', ['**/*.css']);
});

gulp.task('scripts', function(){
    return gulp.src(['app/scripts/app.js', 'app/scripts/polymer.js'])
    .pipe($.browserify())
    .pipe(gulp.dest('dist/scripts'))
    .pipe($.size({
        title: 'scripts'
    }));
});

gulp.task('index', function(){
    return gulp.src('app/*.html')
    .pipe($.htmlmin({collapseWhitespace: true}))
    .pipe(gulp.dest('dist'))
    .pipe($.size({
        title: 'index'
    }));
});

// Optimize images
gulp.task('images', function() {
    return imageOptimizeTask('app/images/**/*', dist('images'));
});

// Copy all files at the root level (app)
gulp.task('copy', function() {
    var app = gulp.src([
        'app/*',
        '!app/test',
        '!app/elements',
        '!app/bower_components',
        '!app/cache-config.json',
        '!**/.DS_Store'
    ], {
        dot: true
    }).pipe(gulp.dest(dist()));

    // Copy over only the bower_components we need
    // These are things which cannot be vulcanized
    var bower = gulp.src([
        'app/bower_components/{webcomponentsjs,platinum-sw,sw-toolbox,promise-polyfill}/**/*'
    ]).pipe(gulp.dest(dist('bower_components')));

    return merge(app, bower)
    .pipe($.size({
        title: 'copy'
    }));
});

// Copy web fonts to dist
gulp.task('fonts', function() {
    return gulp.src(['app/fonts/**'])
    .pipe(gulp.dest(dist('fonts')))
    .pipe($.size({
        title: 'fonts'
    }));
});

// Copy templates of ui router to dist
gulp.task('templates', function() {
    return gulp.src(['app/templates/**/**'])
    .pipe($.htmlmin({collapseWhitespace: true}))
    .pipe(gulp.dest(dist('templates')))
    .pipe($.size({
        title: 'templates'
    }));
});


// Vulcanize granular configuration
gulp.task('vulcanize', function() {
    return gulp.src('app/elements/elements.html')
    .pipe($.vulcanize({
        stripComments: true,
        inlineCss: true,
        inlineScripts: true
    }))
    .pipe(gulp.dest(dist('elements')))
    .pipe($.size({title: 'vulcanize'}));
});

// Watch files for changes & reload
gulp.task('serve', ['styles', 'scripts', 'index', 'templates', 'images', 'vulcanize', 'copy'], function() {
    browserSync({
        port: 5000,
        notify: true,
        logPrefix: 'appPrinta',
        snippetOptions: {
            rule: {
                match: '<span id="browser-sync-binding"></span>',
                fn: function(snippet) {
                    return snippet;
                }
            }
        },
        // Run as an https by uncommenting 'https: true'
        // Note: this uses an unsigned certificate which on first access
        //       will present a certificate warning in the browser.
        // https: true,
        server: {
            baseDir: ['.tmp', 'dist'],
            middleware: [historyApiFallback()]
        }
    });

    gulp.watch(['app/elements/*.html', 'app/styles/*.html'], ['vulcanize', 'styles', reload]);
    gulp.watch(['app/*.html', '!app/bower_components/**/*.html'], ['index', reload]);
    gulp.watch(['app/templates/**/*.html'], ['templates', reload]);
    gulp.watch(['app/styles/**/*.css'], ['styles', reload]);
    gulp.watch(['app/scripts/**/**/*.js'], ['scripts', reload]);
    gulp.watch(['app/images/**/*'], ['images', reload]);
});

// Clean output directory
gulp.task('clean', function() {
    return del(['.tmp', dist()]);
});

var scriptTask = function(scriptsPath, srcs) {
    return gulp.src(srcs.map(function(src) {
        return path.join(scriptsPath, src);
    }))
    .pipe($.changed(scriptsPath, {extension: '.js'}))
    .pipe($.autoprefixer(AUTOPREFIXER_BROWSERS))
    .pipe(gulp.dest('.tmp/' + scriptsPath))
    .pipe($.uglify())
    .pipe(gulp.dest(dist(scriptsPath)))
    .pipe($.size({title: scriptsPath}));
};

var imageOptimizeTask = function(src, dest) {
    return gulp.src(src)
    .pipe($.imagemin({
        progressive: true,
        interlaced: true
    }))
    .pipe(gulp.dest(dest))
    .pipe($.size({title: 'images'}));
};

var optimizeHtmlTask = function(src, dest) {
    var assets = $.useref.assets({
        searchPath: ['.tmp', 'app']
    });

    return gulp.src(src)
    .pipe(assets)
    // Concatenate and minify JavaScript
    .pipe($.if('*.js', $.uglify({
        preserveComments: 'some'
    })))
    // Concatenate and minify styles
    // In case you are still using useref build blocks
    .pipe($.if('*.css', $.minifyCss()))
    .pipe(assets.restore())
    .pipe($.useref())
    // Minify any HTML
    .pipe($.if('*.html', $.minifyHtml({
        quotes: true,
        empty: true,
        spare: true
    })))
    // Output files
    .pipe(gulp.dest(dest))
    .pipe($.size({
        title: 'html'
    }));
};

// Scan your HTML for assets & optimize them
gulp.task('html', function() {
    return optimizeHtmlTask(['app/**/*.html', '!app/{elements,test,bower_components}/**/*.html'],dist());
});

// Generate config data for the <sw-precache-cache> element.
// This include a list of files that should be precached, as well as a (hopefully unique) cache
// id that ensure that multiple PSK projects don't share the same Cache Storage.
// This task does not run by default, but if you are interested in using service worker caching
// in your project, please enable it within the 'default' task.
// See https://github.com/PolymerElements/polymer-starter-kit#enable-service-worker-support
// for more context.
gulp.task('cache-config', function(callback) {
    var dir = dist();
    var config = {
        cacheId: packageJson.name || path.basename(__dirname),
        disabled: false
    };

    glob([
        'index.html',
        './',
        'bower_components/webcomponentsjs/webcomponents-lite.min.js',
        '{elements,scripts,styles}/**/*.*'],
        {cwd: dir}, function(error, files) {
            if (error) {
                callback(error);
            } else {
                config.precache = files;

                var md5 = crypto.createHash('md5');
                md5.update(JSON.stringify(config.precache));
                config.precacheFingerprint = md5.digest('hex');

                var configPath = path.join(dir, 'cache-config.json');
                fs.writeFile(configPath, JSON.stringify(config), callback);
            }
        }
    );
});
