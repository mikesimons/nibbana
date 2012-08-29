fs = require 'fs'
path = require 'path'
cs = require 'coffee-script'
rimraf = require 'rimraf'
browserify = require 'browserify'
mocha = require 'mocha'
ncp = require( 'ncp' ).ncp
which = require 'which'

spawn = require( "child_process" ).spawn

files = [ \
'storage/local.coffee',
'storage/object.coffee',
'tag/abstract.coffee',
'tag/area.coffee',
'tag/contact.coffee',
'tag/context.coffee',
'tag/tag.coffee',
'task/abstract.coffee',
'task/project.coffee',
'task/task.coffee',
'view/factory.coffee',
'view/filters.coffee',
'view/groupers.coffee',
'view/sorters.coffee',
'view/view.coffee',
'constants.coffee',
'cors_hack.coffee',
'entity_map.coffee',
'nibbana.coffee',
'session.coffee',
'util.coffee'
]

task 'clean', 'Clean up build artifacts', ( options ) ->
  rimraf.sync( 'lib' ) if fs.existsSync( 'lib/' )
  rimraf.sync( 'dist' ) if fs.existsSync( 'dist/' )
  rimraf.sync( 'npm_build' ) if fs.existsSync( 'npm_build/' )

task 'compile', 'Compile coffeescript to JS', ( options ) ->
  invoke 'clean'
  fs.mkdirSync( 'lib' )

  for f in files
    in_file = "src/#{f}"
    out_file = "lib/#{f.replace( /coffee$/, 'js' )}"
    opts =
      filename: in_file
      header: true
    console.log( "Compiling #{in_file} to #{out_file}")
    dir = path.dirname( out_file )
    fs.mkdirSync( dir ) if ! fs.existsSync( dir )
    fs.writeFileSync( out_file, cs.compile( fs.readFileSync( in_file ).toString(), opts ) )

task 'publish_npm', 'Build & publish npm', ( options ) ->
  invoke 'compile'
  fs.mkdirSync( 'npm_build' )

  # ncp is a bit messy since we can't do deferred / event stuff with it (AFAIK)
  # We'll do some higher order function magic instead
  publish = ->
    cmd = which.sync( "npm" )
    spawn cmd, [ "publish", "npm_build" ], { customFds: [0,1,2] }

  after_count = ( n, cb ) ->
    cb_ok = 0
    internal_cb = ( err ) ->
      throw err if err
      cb_ok += 1
      cb() if cb_ok == n

  publish_after_done = after_count( 4, publish )

  # Copy files
  ncp( 'lib/', 'npm_build/lib/', publish_after_done )
  ncp( 'README.md', 'npm_build/README.md', publish_after_done )
  ncp( 'LICENSE', 'npm_build/LICENSE', publish_after_done )
  ncp( 'package.json', 'npm_build/package.json', publish_after_done )

task 'browserify', 'Build nibbana for the browser', ( options ) ->
  invoke 'compile'
  fs.mkdirSync( 'dist' )
  b = browserify( )
  b.register('post', (src) ->
    r1 = /require\('([^']+\/node_modules)([^']+)'\)/g
    r2 = /require\.define\("([^"]+\/node_modules)([^"]+)"/g
    src.replace(r1, 'require(\'$2\')').replace(r2, 'require.define("$2"');
  )
  b.ignore( 'jquery' )
  b.require( 'nibbana', target: 'nibbana' )
  b.require( 'node-uuid' )
  b.append( 'require.define("jquery", function(require, module) { module.exports = jQuery; } );' )
  fs.writeFileSync( 'dist/nibbana.js', b.bundle() )

task 'test', 'Run tests', ( options ) ->
  cmd = which.sync( "mocha" )
  options = [ "--recursive", "--compilers", "coffee:coffee-script", "--reporter", "spec", "--require", "coffee-script" ]
  spawn cmd, options, { customFds: [0,1,2] }