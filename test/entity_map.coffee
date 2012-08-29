chai = require 'chai'
entity_map = require '../src/entity_map'

chai.should()

describe 'Entity map', ->
  it 'should map task0 to Task', ->
    ( new entity_map['task0']( { } ) ).constructor.name.should.equal 'Task'
  it 'should map task1 to Project', ->
    ( new entity_map['task1']( { } ) ).constructor.name.should.equal 'Project'
  it 'should map tag0 to Tag', ->
    ( new entity_map['tag0']( { } ) ).constructor.name.should.equal 'Tag'
  it 'should map tag1 to Area', ->
    ( new entity_map['tag1']( { } ) ).constructor.name.should.equal 'Area'
  it 'should map tag2 to Contact', ->
    ( new entity_map['tag2']( { } ) ).constructor.name.should.equal 'Contact'
  it 'should map tag3 to Context', ->
    ( new entity_map['tag3']( { } ) ).constructor.name.should.equal 'Context'