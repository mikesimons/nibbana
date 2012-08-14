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
See the github issue tracker

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