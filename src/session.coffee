uuid = require( 'node-uuid' )
jq = require( 'jquery' )
util = require( './util' )
constants = require( './constants' )

EntityMap = require( './entity_map' )

class Session
  constructor: ( storage ) ->
    @base_url = "https://api.nirvanahq.com/"
    @authtoken = false

    @common_url_params =
      api: "rest"
      requestid: () -> uuid.v4()
      clienttime: () => util.unix_time()
      authtoken: () => @authtoken
      appid: "nirvanahqjs"
      appversion: 0

    @method_map =
      login:
        method: 'POST'
        data:
          method: "auth.new"
          u: ( params ) -> params.username || throw new Error( "Username required to login" )
          p: ( params ) -> params.password || throw new Error( "MD5 hash of password required to login" )
          gmtoffset: new Date().getTimezoneOffset() / -60

      logout:
        method: 'POST'
        data:
          method: "auth.destroy"

      everything:
        method: 'GET'
        url_params:
          method: "everything"
          since: ( params ) -> params.since || 0

      save_task:
        method: 'POST'
        data:
          method: "task.save"

      save_tag:
        method: 'POST'
        data:
          method: "tag.save"

    @storage = storage
    if @storage.has( "authtoken" )
      @authenticate( @storage.get( "authtoken" ) )

  # Internal method to handle common logic of throwing an error from the API.
  _request_error: ( message, deferred ) ->
    return ( data ) =>
      deferred.reject() if deferred
      throw new Error "#{message} (#{data.status} : #{data.statusText})"

  # Internal method to handle common logic of making a request to the API.
  _make_request: ( mapped_method, params ) ->
    # All requests have common data to them which is defined in @common_url_params.
    url_params = jq.extend( {}, @common_url_params )

    # Mapping defines execution parameters and validates arguments.
    mapping = @method_map[ mapped_method ]

    # Merge common url params with method specific params.
    if mapping.url_params
      url_params[ k ] = v for k, v of mapping.url_params

    # Some params require computation / are time sensitive so we apply any parameters that are functions here.
    url_params[ k ] = v( params ) for k, v of url_params when typeof v == "function"

    # opts we'll be passing to jQuery.
    jqdata =
      type: mapping.method

    # If we've an array of params we want to use batch mode of API
    if params.length != undefined
      jqdata.contentType = "application/json"

      payload = []
      for param in params
        data = if mapping.data then jq.extend( {}, mapping.data ) else {}
        data[k] = v for k, v of param
        data[k] = v( param ) for k, v of data when typeof v == "function"
        payload.push data

      payload = JSON.stringify( payload )
      url_params.api = "json"
    else
      payload = if mapping.data then jq.extend( {}, mapping.data ) else {}
      payload[k] = v for k, v of params
      payload[k] = v( params ) for k, v of data when typeof v == "function"

    jqdata.data = payload
    jqdata.url = "#{@base_url}?#{jq.param(url_params)}"

    # Finally we make the request.
    # Unhelpfully the API will return 200 for a server application type error (invalid param or such) so we handle that.
    jq.ajax( jqdata )
    .done( (response) ->
      if response.results && response.results[0].error
        throw new Error "#{response.results[0].error.code} : #{response.results[0].error.message}"
    )

  authenticate: ( username, password, opts = {} ) ->
    dfd = new jq.Deferred
    dfd.done ( token ) => @authtoken = token
    dfd.done ( token ) => @storage.set( "authtoken", token, false )

    # The automatic preload will show if a given authtoken is valid or not.
    if !password
      dfd.resolve( username )
      return @authenticated = dfd.promise()

    @_make_request( "login", { username: username, password: password } )
    .done( ( data ) => dfd.resolve( data.result[0].auth.token ) )
    .fail( @_request_error( "Could not authenticate!", dfd ) )

    return @authenticated = dfd.promise()

  destroy: () ->
    @_make_request( "logout" )
    .done( => @authtoken = null )
    .done( => @storage.remove( "authtoken" ) )
    .fail( @_request_error("Could not logout!") )

  store: ( model ) ->
    @storage.set( model.store_key(), model )

  sync: () ->
    dfd = new jq.Deferred
    task_dfd = new jq.Deferred
    tag_dfd = new jq.Deferred

    dirty = @storage.dirty
    payloads =
      task: []
      tag: []

    for k in dirty
      data = @storage.get( k ).get_data()
      delete data.__internal_type
      key  = if data.type == constants.task.type.TASK || data.type == constants.task.type.PROJECT then "task" else "tag"
      payloads[ key ].push data

    if payloads.task.length > 0
      @_make_request( "save_task", payloads.task )
      .done ( data ) =>
        @_cache_results( data.results )
        task_dfd.resolve( data )
    else
      task_dfd.resolve()

    if payloads.tag.length > 0
      @_make_request( "save_tag", payloads.tag )
      .done ( data ) =>
        @_cache_results( data.results )
        tag_dfd.resolve( data )
    else
      tag_dfd.resolve()

    jq.when( tag_dfd, task_dfd )
    .then =>
      @storage.clear_dirty()
      dfd.resolve()

    return dfd.promise()

  needs_sync: () ->
    @session.storage.dirty.length > 0

  update: ( since = null ) ->
    since = @storage.get( "last_update" ) || 0 if since == null
    dfd = new jq.Deferred

    success = ( data ) =>
      @storage.set( "last_update", util.unix_time() )
      @_cache_results( data.results )
      dfd.resolve( data.results )

    @_make_request( "everything", { since: since } )
    .done( success )
    .fail( @_request_error( "Could not fetch data!", dfd ) )

    return dfd.promise()

  _cache_results: ( results ) ->
    for r in results
      if r.user
        m =
          get_data: -> r.user
          store_key: -> "user-#{r.user.id}"
      else if r.task && r.task.type
        m = new EntityMap["task#{r.task.type}"]( r.task )
      else if r.tag && r.tag.type
        m = new EntityMap["tag#{r.tag.type}"]( r.tag )
      else
        continue

      @store( m )

module.exports = Session