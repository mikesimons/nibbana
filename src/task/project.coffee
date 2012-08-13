AbstractTask = require( './abstract' )
Task = require( './task' )
constants = require( '../constants' )

class Project extends AbstractTask
  constructor: ( data ) ->
    @type = constants.task.type.PROJECT
    super( data )

  to_task: ->
    new_state = if @data.parentid && @data.state == constants.task.state.ACTIVE_PROJECT
      constants.task.state.NEXT
    else if @data.state == constants.task.state.ACTIVE_PROJECT
      constants.task.state.INBOX

    @_set( "state", new_state ) if new_state
    @_set( "type", constants.task.state.TASK )

    t = new Task( @data )
    t.dirty = @dirty
    return t

  sequential: ( toggle = true ) ->
    @_set( "ps", Constants.Project.SEQUENTIAL )
    @

  parallel: ( toggle = true ) ->
    @_set( "ps", Constants.Project.PARALLEL )
    @

  is_sequential: ->
    @data.ps == Constants.Project.SEQUENTIAL

  is_parallel: ->
    @data.ps == Constants.Project.PARALLEL

module.exports = Project