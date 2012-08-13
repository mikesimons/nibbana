AbstractTag = require( './abstract' )
constants = require( '../constants' )

class Tag extends AbstractTag
  constructor: ( data ) ->
    @type = constants.tag.type.TAG
    super( data )

module.exports = Tag