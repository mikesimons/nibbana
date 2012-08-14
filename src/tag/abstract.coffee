jq = require( 'jquery' )
util = require( '../util' )

class AbstractTag
  constructor: ( data ) ->
    @data = @template( data )
    @dirty = []

  get_data: ->
    jq.extend( "__internal_type": @constructor.name, @data )

  store_key:  ->
    "tag-#{@data.key}"

  template: ( data ) ->
    tpl =
      key: ""
      type: @type
      email: ""
      color: ""
      meta: ""
      deleted: 0

    return jq.extend( tpl, data )

  key: ( key ) ->
    return @data.key if key == undefined
    @data.key = key
    @dirty.push "key"
    @

  color: ( color ) ->
    return @data.color if color == undefined
    @data.color = color
    @dirty.push color
    @

  delete: ->
    @data.deleted = util.unix_time()
    @dirty.push "deleted"
    @

  is_deleted: ->
    return @data.deleted > 0

module.exports = AbstractTag