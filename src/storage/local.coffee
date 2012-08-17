ObjectStorage = require('./object')

class LocalStorage
  constructor: ( storage )->
    @localStorage = storage
    @objectStorage = new ObjectStorage
    @dirty = []

  has: ( key ) ->
    @get( key ) == null

  get: ( key ) ->
    return @objectStorage.get( key ) if @objectStorage.has( key )
    data = JSON.parse( @localStorage.getItem( key ) )
    @objectStorage.set( key, data, false )
    return data if data == null || typeof data != "object" || !data.__internal_type
    klass = eval( data.__internal_type )
    data = new klass( data )
    @objectStorage.set( key, data, false )
    return data

  set: ( key, data, make_dirty = true ) ->
    @objectStorage.set( key, data, false )
    data = data.get_data() if data != null && data[ "get_data" ]
    @localStorage.setItem( key, JSON.stringify( data ) )
    @dirty.push key if make_dirty

  remove: ( key ) ->
    @objectStorage.remove( key )
    @localStorage.removeItem( key )

  clear: ( key ) ->
    @objectStorage.clear()
    @localStorage.clear()
    @dirty = []

  map: ( func ) ->
    mapped = []
    for i in [ 0..@localStorage.length - 1 ]
      k = @localStorage.key( i )
      entry = @get( k )
      mapped.push( entry ) if func( k, entry )
    return mapped

  clear_dirty: ->
    @dirty = []

module.exports = LocalStorage