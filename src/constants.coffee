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