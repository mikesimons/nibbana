constants = require( '../constants' )
util = require( '../util' )
jq = require( 'jquery' )
uuid = require( 'node-uuid' )
moment = require( 'moment' )

class AbstractTask
  constructor: ( data, storage ) ->
    @data = @template( data )
    @dirty = []
    @storage = storage

  get_data: ->
    data = jq.extend( "__internal_type": @constructor.name, @data )
    data.tags = ',' + data.tags.join( "," ) + ','
    data.startdate = data.startdate.format( 'YYYYMMDD' ) if data.startdate != ""
    data.duedate = data.duedate.format( 'YYYYMMDD' ) if data.duedate != ""
    return data

  store_key: ->
    "task-#{@data.id}"

  template: ( data ) ->
    tpl =
      id: if !data.id then uuid.v4() else data.id # Simply saves generating a UUID unnecessarily
      name: "Unnamed"
      type: @type
      state: if data.parentid then constants.task.state.NEXT else constants.task.state.INBOX
      parentid: ""
      waitingfor: ""
      completed: 0
      cancelled: 0
      seq: 0
      seqp: 0
      seqt: 0
      tags: []
      note: ""
      ps: 0
      etime: 0
      energy: 0
      startdate: ""
      duedate: ""
      recurring: null

    if typeof data.tags == "string"
      data.tags = data.tags.split( "," ).filter ( t ) -> t != ""

    tpl = jq.extend( tpl, data )

    tpl.duedate = moment( tpl.duedate, 'YYYYMMDD' ) if tpl.duedate != ''
    tpl.startdate = moment( tpl.startdate, 'YYYYMMDD' ) if tpl.startdate != ''

    for k, v of tpl
      if k[0] != '_' && !tpl[ "_#{k}" ]
        tpl[ "_#{k}" ] = util.unix_time()

    return tpl

  _set: ( key, val ) ->
    @dirty.push( key )
    @data[ key ] = val
    @data[ "_#{key}"] = util.unix_time()

  # Basic data ops
  id: ( id ) ->
    return @data.id

  name: ( name ) ->
    return @data.name if name == undefined
    @_set( "name", name )
    @

  note: ( note ) ->
    return @data.note if note == undefined
    @_set( "note", note )
    @

  state: ( state ) ->
    return @data.state if state == undefined
    @_set( "state", state )
    @

  waiting_for: ( waiting_for ) ->
    # TODO create contact if non-existant
    waiting_for = waiting_for.key if typeof waiting_for == "object" && waiting_for.key
    return @data.waitingfor if waiting_for == undefined
    @_set( "waitingfor", waiting_for )
    @

  is_waiting: ->
    @data.waitingfor != ""

  tags: ( tags ) ->
    return @data.tags if tags == undefined
    if tags.constructor && tags.constructor.name == "Array"
      for k, v of tags
        tags[k] = v.key() if typeof v.key == "function"
    else if typeof tags == 'string'
      tags = tags.split(',').filter (t) -> t != ""
    @_set( 'tags', tags )
    @

  due_date: ( due ) ->
    return @data.duedate if due == undefined
    due = moment( due )
    @_set( "duedate", if due then due else "" )
    @

  # Flag-like ops
  focus: ( toggle = true ) ->
    @_set( "seqt", if toggle then util.unix_time() else 0 )
    @

  is_focused: ->
    @data.seqt > 0

  complete: ( toggle = true ) ->
    @_set( "completed", if toggle then util.unix_time() else 0 )
    @

  is_completed: ->
    @data.completed > 0

  cancel: ( toggle = true ) ->
    @_set( "cancelled", toggle )
    @

  is_cancelled: ->
    @data.cancelled > 0

  trash: ->
    @state( constants.task.state.TRASHED )
    @

  is_trashed: ->
    @data.state == constants.task.state.TRASHED

  delete: ->
    delete @data.type
    @state( constants.task.state.DELETED )
    @

  is_deleted: ->
    @data.state == constants.task.state.DELETED

  log: ->
    @state( constants.task.state.LOGGED )
    @

  is_logged: ->
    @data.state == constants.task.state.LOGGED

  # Tag ops
  add_tag: ( tag ) ->
    tag_str = if typeof tag == "string" then tag else tag.key()
    return @ if @data.tags.indexof( tag_str ) > -1

    # Breaking encapsulation a little here
    if typeof tag == "string" && !@storage.has( "tag-#{tag}" )
      t = new Tag( key: tag )
      @storage.set( t.store_key(), t )

    @data.tags.push( tag_str ) unless @data.tags.indexof( tag ) > -1
    @

  remove_tag: ( tag ) ->
    index = @data.tags.indexof( tag )
    @data.tags.splice( index, 1 ) if index > -1
    @

module.exports = AbstractTask