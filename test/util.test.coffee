chai = require 'chai'
util = require '../src/util'

chai.should()

describe 'Unix time', ->
  it 'should return seconds since epoch', ->
    d = new Date
    t = parseInt( d.getTime().toString().slice(0,10) )
    util.unix_time( d ).should.equal( t )

  it 'should return a number', ->
    util.unix_time().should.be.a( 'number' )
