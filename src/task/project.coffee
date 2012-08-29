AbstractTask = require( './abstract' )
Task = require( './task' )
constants = require( '../constants' )

class Project extends AbstractTask
  constructor: ( data ) ->
    @type = constants.task.type.PROJECT
    super( data )

  sequential: ( toggle = true ) ->
    ps = if toggle then constants.project.SEQUENTIAL else constants.project.PARALLEL
    @_set( "ps", ps )
    @

  parallel: ( toggle = true ) ->
    ps = if toggle then constants.project.PARALLEL else constants.project.SEQUENTIAL
    @_set( "ps",  ps )
    @

  is_sequential: ->
    @data.ps == constants.project.SEQUENTIAL

  is_parallel: ->
    @data.ps == constants.project.PARALLEL

  project_order: ( order ) ->
    return @data.seq if order == undefined
    @_set( "seq", order )
    @

module.exports = Project