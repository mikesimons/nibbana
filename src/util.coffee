module.exports =
  # JS returns milliseconds since epoch, not seconds which is what we need.
  unix_time: ( date = new Date ) ->
    Math.floor( date.getTime() / 1000 )
