_num_field_sorter = ( field ) ->
  ( a, b ) ->
    av = parseInt( a.data[ field ] )
    bv = parseInt( b.data[ field ] )
    if av > bv then 1 else ( if av < bv then -1 else 0 )

module.exports =
  task_list: _num_field_sorter( "seqp" )
  project_list: _num_field_sorter( "seq" )