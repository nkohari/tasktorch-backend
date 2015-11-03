_     = require 'lodash'
r     = require 'rethinkdb'
async = require 'async'

Tables = {}

Tables.actions = [
  r.tableCreate('actions')
  r.table('actions').indexCreate('card')
  r.table('actions').indexCreate('org')
  r.table('actions').indexCreate('checklist')
  r.table('actions').indexCreate('stage')
]

Tables.cards = [
  r.tableCreate('cards')
  r.table('cards').indexCreate('followers', {multi: true})
  r.table('cards').indexCreate('goals', {multi: true})
  r.table('cards').indexCreate('kind')
  r.table('cards').indexCreate('org')
  r.table('cards').indexCreate('stack')
]

Tables.checklists = [
  r.tableCreate('checklists')
  r.table('checklists').indexCreate('actions', {multi: true})
  r.table('checklists').indexCreate('card')
  r.table('checklists').indexCreate('stage')
]

Tables.events = [
  r.tableCreate('events')
  r.table('events').indexCreate('user')
  r.table('events').indexCreate('org')
]

Tables.goals = [
  r.tableCreate('goals')
  r.table('goals').indexCreate('org')
]

Tables.invites = [
  r.tableCreate('invites')
  r.table('invites').indexCreate('org')
]

Tables.kinds = [
  r.tableCreate('kinds')
  r.table('kinds').indexCreate('org')
]

Tables.memberships = [
  r.tableCreate('memberships')
  r.table('memberships').indexCreate('org')
  r.table('memberships').indexCreate('user')
]

Tables.notes = [
  r.tableCreate('notes')
  r.table('notes').indexCreate('card')
  r.table('notes').indexCreate('org')
  r.table('notes').indexCreate('user')
  r.table('notes').indexCreate('action', (note) -> 
    r.branch(note.hasFields({content: {action: true}}), note('content')('action'), null)
  )
]

Tables.orgs = [
  r.tableCreate('orgs')
  r.table('orgs').indexCreate('account', r.row('account')('id'))
]

Tables.profiles = [
  r.tableCreate('profiles')
  r.table('profiles').indexCreate('user-org', [r.row('user'), r.row('org')])
]

Tables.sessions = [
  r.tableCreate('sessions')
  r.table('sessions').indexCreate('user')
]

Tables.stacks = [
  r.tableCreate('stacks')
  r.table('stacks').indexCreate('cards', {multi: true})
  r.table('stacks').indexCreate('org')
  r.table('stacks').indexCreate('team')
  r.table('stacks').indexCreate('user')
]

Tables.stages = [
  r.tableCreate('stages')
  r.table('stages').indexCreate('kind')
]

Tables.teams = [
  r.tableCreate('teams')
  r.table('teams').indexCreate('members', {multi: true})
  r.table('teams').indexCreate('org')
]

Tables.tokens = [
  r.tableCreate('tokens')
]

Tables.users = [
  r.tableCreate('users')
  r.table('users').indexCreate('email')
  r.table('users').indexCreate('username')
]

DatabaseCreator = {}

DatabaseCreator.create = (dbname, options = {}, callback) ->
  r.connect options, (err, conn) ->
    return callback(err) if err?
    r.dbCreate(dbname).run conn, (err) ->
      return callback(err) if err?
      conn.use(dbname)
      statements = _.flatten _.values(Tables)
      async.eachSeries statements, ((statement, next) -> statement.run(conn, next)), (err) ->
        return callback(err) if err?
        callback()

module.exports = DatabaseCreator
