constants = require( '../constants' )

_ctor_filter = ( ctor ) -> ( k, e ) -> e.constructor && e.constructor.name == ctor
_state_filter = ( target ) -> ( k, e ) -> e.data && e.data.state && e.data.state == target

module.exports =
  projects: _ctor_filter( "NibbanaProject" )
  tasks: _ctor_filter( "NibbanaTask" )
  tags: _ctor_filter( "NibbanaTag" )
  areas: _ctor_filter( "NibbanaArea" )
  contexts: _ctor_filter( "NibbanaContext" )
  contacts: _ctor_filter( "NibbanaContact" )
  inbox: _state_filter( constants.task.state.INBOX )
  next: _state_filter( constants.task.state.NEXT )
  later: _state_filter( constants.task.state.LATER )
  waiting: _state_filter( constants.task.state.WAITING )
  scheduled: _state_filter( constants.task.state.SCHEDULED )
  someday: _state_filter( constants.task.state.SOMEDAY )
  trashed: _state_filter( constants.task.state.TRASHED )
  deleted: _state_filter( constants.task.state.DELETED )
  completed: ( k, e ) -> e.data && e.data.completed != "0"
  incomplete: ( k, e ) -> e.data && e.data.completed == "0"
  inactive: ( k, e ) -> e.data && e.data.state && ( e.data.state == constants.task.state.LATER || e.data.state == constants.task.state.SOMEDAY )
  focused: ( k, e ) -> e.data && e.data.seqt && e.data.seqt != "0"
  in_project: ( p ) -> ( k, e ) -> e.data.parentid == p.data.id
  tagged_with: ( t ) -> ( k, e ) -> e.data && e.data.tags && e.data.tags.indexOf( t ) > -1
  and: ( a, b ) -> ( k, e ) -> a( k, e ) && b( k, e )
  dsl: ( f ) ->
    f.apply( this )
  search: ( term ) ->
    # Parse term for rapid entry params and build filter from above
