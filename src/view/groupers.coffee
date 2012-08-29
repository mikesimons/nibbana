module.exports =
  state: ( e ) -> e.state && e.state()
  project: ( e ) -> e.parent_id && e.parent_id()