LocalStorage = require '../../src/storage/local'
chai = require 'chai'

chai.should()

window = null
fake_object_storage = null

describe 'Local storage', ->
  beforeEach ->
    window =
      data: {}
      localStorage:
        setItem: ( k, v ) ->
          window.data[k] = v

        getItem: ( k ) ->
          window.data[k]

        removeItem: ( k ) ->
          delete window.data[k]

        clear: ->
          window.data = {}


    Object.defineProperty( \
      window.localStorage,
      'length',
      get: ->
        Object.keys( @ ).length - 2
    )

    fake_object_storage =
      has: -> false
      get: -> undefined
      set: -> false
      remove: -> false
      clear: -> false

  it 'should return true if collection has key', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value' )
    s.has( 'key' ).should.be.true

  it 'should return false if collection does not have key', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.has( 'key' ).should.be.false

  it 'should set key value', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value' )
    s.get( 'key' ).should.equal 'value'

  it 'should set dirty flag for key on set', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value' )
    s.is_dirty( 'key' ).should.be.true

  it 'should not set dirty flag for key on set if told not to', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value', make_dirty: false )
    s.is_dirty( 'key' ).should.be.false

  it 'should remove entry from collection', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value' )
    s.remove( 'key' )
    s.has( 'key' ).should.be.false

  it 'should unset dirty flag for removed key', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value' )
    s.remove( 'key' )
    s.is_dirty( 'key' ).should.be.false

  it 'should clear all entries', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    s.set( 'key', 'value' )
    s.set( 'key1', 'value1' )
    s.clear()
    ( typeof s.get( 'key' ) ).should.equal "undefined"
    ( typeof s.get( 'key1' ) ).should.equal "undefined"
    s.dirty_list().should.be.empty

  it 'should iterate all entries applying map function'

  it 'should return undefined when getting a non existant key', ->
    s = new LocalStorage( window.localStorage, fake_object_storage )
    ( typeof s.get( 'non-existant' ) ).should.equal "undefined"

  it 'should return JSON parsed object if parsable'
  it 'should return instance of __instance_type if set'