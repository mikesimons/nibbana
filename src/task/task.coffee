AbstractTask = require( './abstract' )
Project = require( './project' )
constants = require( '../constants' )

class Task extends AbstractTask
  constructor: ( data, storage ) ->
    @type = constants.task.type.TASK
    super( data, storage )

  to_project: ->
    active = ( @data.state != constants.task.state.LATER && @data.state != constants.task.state.SOMEDAY )
    @state( constants.task.state.ACTIVE_PROJECT ) if active
    @_set( "type", constants.task.type.PROJECT )
    p = new Project( @data )
    p.dirty = @dirty
    return p

  # Parent ops
  set_parent: ( parent ) ->
    parent = parent.id if typeof parent == "object" && parent.id
    @_set( "parentid", parent )
    @

  parentid: ( parentid ) ->
    return @data.parentid if parentid == undefined
    @_set( "parentid", parentid )
    @

  parent: ( parent ) ->
    return @storage.get( @parentid() ) if parent == undefined
    @_set( "parentid", parent.id )
    @

  # Basic ops
  schedule_for: ( start ) ->
    @_set( "startdate", if start then start else "" )
    @state( constants.task.state.SCHEDULED )
    @

  scheduled_for: () ->
    return @data.start

  estimated_time: ( time ) ->
    return @data.etime if time == undefined
    @_set( "etime", time )
    @

  energy: ( energy ) ->
    return @data.energy if energy == undefined
    @_set( "energy", energy )
    @

module.exports = Task