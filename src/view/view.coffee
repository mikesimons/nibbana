class View
  constructor: ( storage, opts = {} ) ->
    @sort = if opts.sort then opts.sort else null
    @filter = if opts.filter then opts.filter else -> true
    @group = if opts.group then opts.group else null
    @storage = storage

  get: ( params = {} ) ->
    view = @storage.map( @filter )
    view = view.sort( @sort ) if @sort
    grouped = {}
    if @group
      for e in view
        g = @group( e )
        grouped[ g ] = [] if !grouped[ g ]
        grouped[ g ].push( e )
      return grouped

    return view

  tags: ->
    tasks = @get()
    tags = []
    for t in tasks
      tags.concat(t.tags())

    # TODO uniq tags
    return tags

module.exports = View