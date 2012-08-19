module.exports =
  task:
    state:
      INBOX: "0"
      NEXT: "1"
      WAITING: "2"
      SCHEDULED: "3"
      SOMEDAY: "4"
      LATER: "5"
      TRASHED: "6"
      LOGGED: "7"
      DELETED: "8"
      RECURRING: "9"
      ACTIVE_PROJECT: "11"

    type:
      TASK: "0"
      PROJECT: "1"

  project:
    PARALLEL: 0
    SEQUENTIAL: 1

  tag:
    type:
      TAG: "0"
      AREA: "1"
      CONTACT: "2"
      CONTEXT: "3"

  reverse:
    task:
      state:
        0: "Inbox"
        1: "Next"
        2: "Waiting"
        3: "Scheduled"
        4: "Some day"
        5: "Later"
        6: "Trashed"
        7: "Logged"
        8: "Deleted"
        9: "Recurring"
        11: "Active project"

      type:
        0: "Task"
        1: "Project"

    project:
      0: "Parallel"
      1: "Sequential"

    tag:
      type:
        0: "Tag"
        1: "Area"
        2: "Contact"
        3: "Context"