View = require( './view' )
Sorters = require( './sorters' )
Groupers = require( './groupers' )
Filters = require( './filters' )

module.exports =
  task_list: ( storage, project ) ->
    new View storage,
      sort: Sorters.task_list
      filter: Filters.dsl( -> @and( @tasks, @in_project( project ) ) )
      group: Groupers.state

  project_list: ( storage ) ->
    new View storage,
      sort: Sorters.project_list
      filter: Filters.dsl( -> @and( @projects, @incomplete ) )