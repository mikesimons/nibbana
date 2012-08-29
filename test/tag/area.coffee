chai = require 'chai'
Area = require '../../src/tag/area'
constants = require( '../../src/constants' )
moment = require 'moment'

chai.should()

describe 'Area', ->
  it 'should return storage key', ->
    t = new Area key: "TEST"
    t.store_key().should.equal "tag-TEST"

  it 'should return key', ->
    t = new Area key: "TEST"
    t.key().should.equal "TEST"

  it 'should return color', ->
    t = new Area color: 'fff'
    t.color().should.equal 'fff'

  it 'should mark task deleted', ->
    t = new Area {}
    t.is_deleted().should.be.false
    t.delete()
    t.is_deleted().should.be.true

  it 'should set key', ->
    t = new Area {}
    t.key( 'TEST' )
    t.key().should.equal 'TEST'

  it 'should set color', ->
    t = new Area {}
    t.color( 'fff' )
    t.color().should.equal 'fff'

  it 'should export all necessary fields', ->
    t = new Area key: "TEST", color: 'fff'

    data = t.get_data()
    data.should.have.property( 'key' )
    data.key.should.equal 'TEST'

    data.should.have.property( 'color' )
    data.color.should.equal 'fff'

    data.should.have.property( 'type' )
    data.type.should.equal constants.tag.type.AREA

    data.should.have.property( 'email' )
    data.email.should.equal ''

    data.should.have.property( 'meta' )
    data.meta.should.equal ''

    data.should.have.property( 'deleted' )
    data.deleted.should.equal 0
