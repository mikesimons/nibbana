class ObjectStorage
  constructor: ->
    @data = {}
    @dirty = []

  has: ( key ) ->
    if @data[ key ] then true else false

  get: ( key ) ->
    @data[ key ]

  set: ( key, data, opts = { make_dirty: true } ) ->
    @data[ key ] = data
    @dirty.push( key ) if opts.make_dirty

  remove: ( key ) ->
    delete @data[ key ]
    @dirty.splice( i, 1 ) if ( i = @dirty.indexOf( key ) ) > -1

  clear: ( key ) ->
    for k, v of @data
      delete @data[ key ]
    @data = {}
    @clear_dirty()

  map: ( func ) ->
    mapped = []
    mapped.push( e ) for k, e of @data when func( k, e )
    return mapped

  is_dirty: ( key ) ->
    @dirty.indexOf( key ) != -1

  clear_dirty: ->
    @dirty = []

  dirty_list: ->
    @dirty

module.exports = ObjectStorage