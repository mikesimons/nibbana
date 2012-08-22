ObjectStorage = require('./object')

class LocalStorage
  constructor: ( storage, object_storage = new ObjectStorage )->
    @localStorage = storage
    @objectStorage = object_storage
    @dirty = []

  has: ( key ) ->
    @get( key ) != undefined

  get: ( key ) ->
    # Check object cache
    return @objectStorage.get( key ) if @objectStorage.has( key )

    # Object cache doesn't have it, check local storage
    data = @localStorage.getItem( key )
    return undefined if data == null

    try
      parsed_data = JSON.parse( data )
    catch error
      return data

    return data if !parsed_data.__internal_type

    # Stored object exists and is a JSON encoded object
    # Create instance, store and return
    klass = eval( parsed_data.__internal_type )
    instance = new klass( parsed_data )
    @objectStorage.set( key, instance, make_dirty: false )

    return instance

  set: ( key, data, opts = { make_dirty: true } ) ->
    @objectStorage.set( key, data, make_dirty: false )
    if data != null && data[ "get_data" ]
      data = JSON.stringify( data.get_data() )

    @localStorage.setItem( key, data )
    @dirty.push( key ) if opts.make_dirty

  remove: ( key ) ->
    @objectStorage.remove( key )
    @localStorage.removeItem( key )
    @dirty.splice( i, 1 ) if ( i = @dirty.indexOf( key ) ) > -1

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

  is_dirty: ( key ) ->
    @dirty.indexOf( key ) != -1

  clear_dirty: ->
    @dirty = []

  dirty_list: ->
    @dirty

module.exports = LocalStorage