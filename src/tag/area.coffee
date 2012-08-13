AbstractTag = require( './abstract' )
constants = require( '../constants' )

class Area extends AbstractTag
  constructor: ( data ) ->
    @type = constants.tag.type.AREA
    super( data )

module.exports = Area