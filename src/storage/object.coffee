class ObjectStorage
  constructor: ->
    @data = {}
    @dirty = []

  has: ( key ) ->
    if @data[ key ] then true else false

  get: ( key ) ->
    @data[ key ]

  set: ( key, data, make_dirty = true ) ->
    @data[ key ] = data
    @dirty.push key if make_dirty

  remove: ( key ) ->
    delete @data[ key ]

  clear: ( key ) ->
    for k, v of @data
      delete @data[ key ]
    @data = {}

  map: ( func ) ->
    mapped = []
    mapped.push( e ) for k, e of @data when func( k, e )
    return mapped

  clear_dirty: ->
    @dirty = []

module.exports = ObjectStorage