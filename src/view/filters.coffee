constants = require( '../constants' )

_ctor_filter = ( ctor ) -> ( k, e ) -> e.constructor && e.constructor.name == ctor
_state_filter = ( target ) -> ( k, e ) -> e.state && e.state() == target

module.exports =

  projects: _ctor_filter( "Project" )
  tasks: _ctor_filter( "Task" )
  tags: _ctor_filter( "Tag" )
  areas: _ctor_filter( "Area" )
  contexts: _ctor_filter( "Context" )
  contacts: _ctor_filter( "Contact" )

  inbox: _state_filter( constants.task.state.INBOX )
  next: _state_filter( constants.task.state.NEXT )
  later: _state_filter( constants.task.state.LATER )
  waiting: _state_filter( constants.task.state.WAITING )
  scheduled: _state_filter( constants.task.state.SCHEDULED )
  someday: _state_filter( constants.task.state.SOMEDAY )
  trashed: _state_filter( constants.task.state.TRASHED )
  deleted: _state_filter( constants.task.state.DELETED )

  overdue: ( k, e ) -> e.due_date().toDate() < new Date

  completed: ( k, e ) -> e.is_completed && e.is_completed()
  incomplete: ( k, e ) -> e.is_completed && !e.is_completed()
  focused: ( k, e ) -> e.is_focused && e.is_focused()
  inactive: ( k, e ) ->
    return false if !e.state
    s = e.state()
    return  s == constants.task.state.LATER || s == constants.task.state.SOMEDAY

  in_project: ( p ) -> ( k, e ) -> e.parent_id && e.parent_id() == p.id()
  tagged_with: ( t ) -> ( k, e ) -> e.data && e.data.tags && e.data.tags.indexOf( t ) > -1
  and: ( a, b ) -> ( k, e ) -> a( k, e ) && b( k, e )
  dsl: ( f ) ->
    f.apply( this )
  search: ( term ) ->
    # Parse term for rapid entry params and build filter from above
