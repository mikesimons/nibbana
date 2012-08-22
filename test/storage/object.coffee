ObjectStorage = require '../../src/storage/object'
chai = require 'chai'

chai.should()

describe 'Object storage', ->
  it 'should return true if collection has key', ->
    s = new ObjectStorage
    s.set( 'key', 'value' )
    s.has( 'key' ).should.be.true

  it 'should return false if collection does not have key', ->
    s = new ObjectStorage
    s.has( 'key' ).should.be.false

  it 'should set key value', ->
    s = new ObjectStorage
    s.set( 'key', 'value' )
    s.get( 'key' ).should.equal 'value'

  it 'should set dirty flag for key on set', ->
    s = new ObjectStorage
    s.set( 'key', 'value' )
    s.is_dirty( 'key' ).should.be.true

  it 'should not set dirty flag for key on set if told not to', ->
    s = new ObjectStorage
    s.set( 'key', 'value', make_dirty: false )
    s.is_dirty( 'key' ).should.be.false

  it 'should remove entry from collection', ->
    s = new ObjectStorage
    s.set( 'key', 'value' )
    s.remove( 'key' )
    s.has( 'key' ).should.be.false

  it 'should unset dirty flag for removed key', ->
    s = new ObjectStorage
    s.set( 'key', 'value' )
    s.remove( 'key' )
    s.is_dirty( 'key' ).should.be.false

  it 'should clear all entries', ->
    s = new ObjectStorage
    s.set( 'key', 'value' )
    s.set( 'key1', 'value1' )
    s.clear()
    ( typeof s.get( 'key' ) ).should.equal "undefined"
    ( typeof s.get( 'key1' ) ).should.equal "undefined"
    s.dirty_list().should.be.empty

  it 'should iterate all entries applying map function'