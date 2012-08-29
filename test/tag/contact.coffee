chai = require 'chai'
Contact = require '../../src/tag/contact'
constants = require( '../../src/constants' )
moment = require 'moment'

chai.should()

describe 'Contact', ->
  it 'should return storage key', ->
    t = new Contact key: "TEST"
    t.store_key().should.equal "tag-TEST"

  it 'should return key', ->
    t = new Contact key: "TEST"
    t.key().should.equal "TEST"

  it 'should return color', ->
    t = new Contact color: 'fff'
    t.color().should.equal 'fff'

  it 'should mark task deleted', ->
    t = new Contact {}
    t.is_deleted().should.be.false
    t.delete()
    t.is_deleted().should.be.true

  it 'should set key', ->
    t = new Contact {}
    t.key( 'TEST' )
    t.key().should.equal 'TEST'

  it 'should set color', ->
    t = new Contact {}
    t.color( 'fff' )
    t.color().should.equal 'fff'

  it 'should set email', ->
    t = new Contact {}
    t.email( 'test@test' )
    t.email().should.equal 'test@test'

  it 'should export all necessary fields', ->
    t = new Contact key: "TEST", color: 'fff', email: 'test@test'

    data = t.get_data()
    data.should.have.property( 'key' )
    data.key.should.equal 'TEST'

    data.should.have.property( 'color' )
    data.color.should.equal 'fff'

    data.should.have.property( 'type' )
    data.type.should.equal constants.tag.type.CONTACT

    data.should.have.property( 'email' )
    data.email.should.equal 'test@test'

    data.should.have.property( 'meta' )
    data.meta.should.equal ''

    data.should.have.property( 'deleted' )
    data.deleted.should.equal 0
