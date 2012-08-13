AbstractTag = require( './abstract' )
constants = require( '../constants' )

class Context extends AbstractTag
  constructor: ( data ) ->
    @type = constants.tag.type.CONTEXT
    super( data )

module.exports = Context