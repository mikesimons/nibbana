chai = require 'chai'
Context = require '../../src/tag/context'
constants = require( '../../src/constants' )
moment = require 'moment'

chai.should()

describe 'Context', ->
  it 'should return storage key', ->
    t = new Context key: "TEST"
    t.store_key().should.equal "tag-TEST"

  it 'should return key', ->
    t = new Context key: "TEST"
    t.key().should.equal "TEST"

  it 'should return color', ->
    t = new Context color: 'fff'
    t.color().should.equal 'fff'

  it 'should mark task deleted', ->
    t = new Context {}
    t.is_deleted().should.be.false
    t.delete()
    t.is_deleted().should.be.true

  it 'should set key', ->
    t = new Context {}
    t.key( 'TEST' )
    t.key().should.equal 'TEST'

  it 'should set color', ->
    t = new Context {}
    t.color( 'fff' )
    t.color().should.equal 'fff'

  it 'should export all necessary fields', ->
    t = new Context key: "TEST", color: 'fff'

    data = t.get_data()
    data.should.have.property( 'key' )
    data.key.should.equal 'TEST'

    data.should.have.property( 'color' )
    data.color.should.equal 'fff'

    data.should.have.property( 'type' )
    data.type.should.equal constants.tag.type.CONTEXT

    data.should.have.property( 'email' )
    data.email.should.equal ''

    data.should.have.property( 'meta' )
    data.meta.should.equal ''

    data.should.have.property( 'deleted' )
    data.deleted.should.equal 0
