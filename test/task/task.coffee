chai = require 'chai'
Task = require '../../src/task/task'
Project = require '../../src/task/project'
Tag = require '../../src/tag/tag'
constants = require '../../src/constants'
moment = require 'moment'

chai.should()

describe 'Task', ->
  describe 'get accessor', ->

    it 'should return id', ->
      t = new Task id: 'UUID'
      t.id().should.equal 'UUID'

    it 'should return name', ->
      t = new Task name: 'name'
      t.name().should.equal 'name'

    it 'should return state', ->
      t = new Task state: 0
      t.state().should.equal 0

    it 'should return parentid', ->
      t = new Task parentid: 'UUID'
      t.parentid().should.equal 'UUID'

    it 'should return "waiting for" value', ->
      t = new Task waitingfor: 'Someone'
      t.waiting_for().should.equal 'Someone'

    it 'should return task list order', ->
      t = new Task seqp: 1
      t.task_order().should.equal 1

    it 'should return tags as array', ->
      t = new Task tags: ",tag1,tag2,tag3,"
      t.tags().join(',').should.equal 'tag1,tag2,tag3'

    it 'should return note', ->
      t = new Task note: 'note'
      t.note().should.equal 'note'

    it 'should return estimated time', ->
      t = new Task etime: 360
      t.estimated_time().should.equal 360

    it 'should return energy required', ->
      t = new Task energy: 3
      t.energy().should.equal 3

    it 'should return scheduled for date', ->
      t = new Task startdate: '20120814'
      t.scheduled_for().format( 'YYYYMMDD' ).should.equal '20120814'

    it 'should return due date', ->
      t = new Task duedate: '20120814'
      t.due_date().format( 'YYYYMMDD' ).should.equal '20120814'

  describe 'get entity accessor', ->
    it 'should return parent', ->
      fake_storage =
        get: () -> new Project( id: 'UUID-parent' )

      t = new Task( parentid: 'UUID', fake_storage )
      p = t.parent()
      p.constructor.name.should.equal 'Project'
      p.id().should.equal 'UUID-parent'

    it 'should return "waiting for" contact'
    it 'should return instances of tags as array'

  describe 'flag accessor', ->
    it 'should return focused state', ->
      t = new Task {}
      t.focus( true )
      t.is_focused().should.equal true

    it 'should return completed status', ->
      t = new Task {}
      t.complete( true )
      t.is_completed().should.equal true

    it 'should return cancelled status', ->
      t = new Task {}
      t.cancel()
      t.is_cancelled().should.equal true

    it 'should return trashed status', ->
      t = new Task {}
      t.trash( true )
      t.is_trashed().should.equal true

    it 'should return deleted status', ->
      t = new Task {}
      t.delete( true )
      t.is_deleted().should.equal true

    it 'should return logged status', ->
      t = new Task {}
      t.log( true )
      t.is_logged().should.equal true

    it 'should return recurring status', ->
      t = new Task recurring: 1
      t.is_recurring().should.equal true

    it 'should return waiting status', ->
      t = new Task {}
      t.waiting_for( 'Someone' )
      t.is_waiting().should.equal true

  describe 'set accessor', ->
    it 'should set name', ->
      t = new Task {}
      t.name( 'name' )
      t.name().should.equal 'name'

    it 'should set parentid', ->
      t = new Task {}
      t.parentid( 'uuid' )
      t.parentid().should.equal 'uuid'

    it 'should set "waiting for" value', ->
      t = new Task {}
      t.waiting_for( 'Someone' )
      t.waiting_for().should.equal 'Someone'

    it 'should set task list order', ->
      t = new Task {}
      t.task_order( 1 )
      t.task_order().should.equal 1

    it 'should set tags', ->
      t = new Task {}
      t.tags( [ "1", "2" ] )
      t.tags().join(',').should.equal '1,2'

    it 'should set note', ->
      t = new Task {}
      t.note( 'note' )
      t.note().should.equal 'note'

    it 'should set estimate time', ->
      t = new Task {}
      t.estimated_time( 360 )
      t.estimated_time().should.equal 360

    it 'should set energy required', ->
      t = new Task {}
      t.energy( 3 )
      t.energy().should.equal 3

    it 'should set start date', ->
      t = new Task {}
      target = moment([2012, 8, 10])
      t.schedule_for( target )
      t.scheduled_for().format( 'YYYYMMDD' ).should.equal target.format( 'YYYYMMDD' )

    it 'should set due date', ->
      t = new Task {}
      target = moment([2012, 8, 10])
      t.due_date( target )
      t.due_date().format( 'YYYYMMDD' ).should.equal target.format( 'YYYYMMDD' )

    it 'should set recurring status'

  describe 'set entity accessor', ->
    it 'should set parentid from project', ->
      p = id: 'PARENTID'
      t = new Task {}
      t.set_parent( p )
      t.parentid().should.equal 'PARENTID'

    it 'should set "waiting for" value from contact', ->
      tag = key: 'TAG'
      t = new Task {}
      t.waiting_for( tag )
      t.waiting_for().should.equal 'TAG'

    it 'should set tags from array of tag entities', ->
      tags = [ new Tag( key: '1' ), new Tag( key: '2' ) ]
      t = new Task {}
      t.tags( tags )
      t.tags().join( ',' ).should.equal '1,2'

    it 'should set start date from Date object', ->
      t = new Task {}
      target = moment([2012, 8, 10])
      t.schedule_for( target.toDate() )
      t.scheduled_for().format( 'YYYYMMDD' ).should.equal target.format( 'YYYYMMDD' )

    it 'should set due date from Date object', ->
      t = new Task {}
      target = moment([2012, 8, 10])
      t.due_date( target.toDate() )
      t.due_date().format( 'YYYYMMDD' ).should.equal target.format( 'YYYYMMDD' )

  describe 'special accessors', ->
    it 'should return expected store key', ->
      t = new Task id: 'ABC'
      t.store_key().should.equal 'task-ABC'

    it 'should set __internal_type on exported data', ->
      t = new Task {}
      t.get_data().__internal_type.should.equal 'Task'

  describe 'api compatibility', ->
    it 'should set modified time for property', ->
      start = Math.floor( new Date().getTime() / 1000 )
      t = new Task {}
      t.name( 'test' )
      data = t.get_data()
      data._name.should.not.be.undefined
      data._name.should.be.a 'number'
      ( data._name >= start ).should.be.true

    it 'should export due date as YYYYMMDD', ->
      t = new Task {}
      d = moment( [ 2012, 8, 23 ] )
      t.due_date( d )
      data = t.get_data()
      data.duedate.should.equal d.format( 'YYYYMMDD' )

    it 'should export start date as YYYYMMDD', ->
      t = new Task {}
      d = moment( [ 2012, 8, 23 ] )
      t.schedule_for( d )
      data = t.get_data()
      data.startdate.should.equal d.format( 'YYYYMMDD' )

    it 'should set seqt for focused', ->
      t = new Task {}
      t.focus()
      data = t.get_data()
      ( data.seqt > 0 ).should.be.true

    it 'should set state to deleted for deletion', ->
      t = new Task {}
      t.delete()
      data = t.get_data()
      data.state.should.equal "8"

    it 'should set completed to timestamp for completion', ->
      t = new Task {}
      t.complete()
      data = t.get_data()
      ( data.completed > 0 ).should.be.true

    it 'should set etime to minutes estimated', ->
      t = new Task {}
      t.estimated_time( 200 )
      data = t.get_data()
      data.etime.should.equal 200

    it 'should export tags as comma delimited string', ->
      t = new Task {}
      t.tags( [ 1, 2, 3 ] )
      data = t.get_data()
      data.tags.should.equal ',1,2,3,'

    it 'should provide defaults for all fields', ->
      t = new Task {}
      data = t.get_data()
      data.should.have.property( 'id' )
      data.id.should.not.be.empty

      data.should.have.property( 'name' )
      data.name.should.equal 'Unnamed'

      data.should.have.property( 'type' )
      data.type.should.equal constants.task.type.TASK

      data.should.have.property( 'state' )
      data.state.should.equal constants.task.state.INBOX

      data.should.have.property( 'parentid' )
      data.parentid.should.equal ''

      data.should.have.property( 'waitingfor' )
      data.waitingfor.should.equal ''

      data.should.have.property( 'completed' )
      data.completed.should.equal 0

      data.should.have.property( 'cancelled' )
      data.cancelled.should.equal 0

      data.should.have.property( 'seq' )
      data.seq.should.equal 0

      data.should.have.property( 'seqp' )
      data.seqp.should.equal 0

      data.should.have.property( 'seqt' )
      data.seqt.should.equal 0

      data.should.have.property( 'tags' )
      data.tags.should.equal ',,'

      data.should.have.property( 'note' )
      data.note.should.equal ''

      data.should.have.property( 'ps' )
      data.ps.should.equal 0

      data.should.have.property( 'etime' )
      data.etime.should.equal 0

      data.should.have.property( 'energy' )
      data.energy.should.equal 0

      data.should.have.property( 'startdate' )
      data.startdate.should.equal ''

      data.should.have.property( 'duedate' )
      data.duedate.should.equal ''

      data.should.have.property( 'recurring' )
      ( data.recurring == null ).should.be.true
