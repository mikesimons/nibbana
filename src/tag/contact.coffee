AbstractTag = require( './abstract' )
constants = require( '../constants' )

class Contact extends AbstractTag
  constructor: ( data ) ->
    @type = constants.tag.type.CONTACT
    super( data )

  email: ( email ) ->
    return @data.email if email == undefined
    @data.email = email
    @dirty.push "email"
    @

module.exports = Contact