# Nibbana
Nibbana is an unofficial client to NirvanaHQ written in coffeescript and deployed as an NPM module.
It currently supports (arbitrary percentage above 60)% of the known features of the NirvanaHQ web app.

# Installing

    npm install nibbana

# Quick start

    Nibbana = require 'nibbana'

    # Create storage for tasks
    # You could use Nibbana.ObjectStorage too for node
    storage = new Nibbana.LocalStorage( window.localStorage )

    # Initiate the session
    nibbana = new Nibbana.Session( storage )

    # Authenticate
    nibbana
    .authenticate( <username>, <password> )
    .pipe -> nibbana.update()
    .done ->
      # Show a task list grouped by state for the first project
      projects = Nibbana.ViewFactory.project_list( nibbana.storage ).get()
      tasks = Nibbana.ViewFactory.task_list( nibbana.storage, projects[0] ).get()
      console.log( "Project: #{projects[0].name()}" )
      for group, task_list of task_view.get()
        console.log( group )
        console.log( "  #{task.name()}" ) for task in task_list

# Known issues
Nibbana has the following known issues:

 * Offline mode is untested
 * Specs aren't finished
 * Recurring tasks are not yet supported
 * Adding non-existant tags to a task / project is untested
 * Tag management on tasks is unfinished
 * Views presently dip in to data backing model
 * No way to get list of tags given list of tasks
 * No counts for tasks / tags / projects
 * No indexing so multiple executions of views have to scan storage again even if not changed
  * Need to add a hashing method for filter methods and index by task + hash: result
 * No views for tags
 * No waiting or scheduled views
 * Potential race conditions between update and sync that could result in data loss
 * Weak / no docs
 * No constant -> string conversions
 * API representations of data is unnecessarily exposed in a couple of places
 * Untested with max_project restricted account
 * No persistent storage for server side
 * Models return defaults for some things when false / null would be more appropriate
 * browserify build is totally broken due to internal requires

# TODO
 * Implement recurring tasks
 * Complete missing specs
 * Implement API compat test suite with break notification
 * Configure project for travis ci
 * Implement offline mode
 * Finish tag implementation
 * Tidy up and fill out view implementation
 * Add views for tags
 * Add counts for views
 * Implement indexing for storage map
 * Implement locks to prevent sync / update race
 * Document API, usage of library in multiple scenarios
 * Fix browserify build

# Why?
Although the NirvanaHQ team has a project in the works, it has taken a while just to get the iphone version of NirvanaHQ out.
The mobile website is pretty awful to use even on a latest generation android device.

As such I decided I'd write my own NirvanaHQ android app sing PhoneGap and this is the first step towards that.

# Will using the API allow me to get around the plan limits?
Nope.

# Pitfalls
I'm not a member of the NirvanaHQ team nor am I in any way affiliated with them.
As such I am not privvy to changes in the API or their future plans regarding access of it.

That means that this shit could break at a moments notice in unreparable ways.
If there is a way to fix it I'll do what I can but no promises.

You've been warned.