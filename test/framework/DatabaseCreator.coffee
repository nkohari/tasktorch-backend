_     = require 'lodash'
r     = require 'rethinkdb'
async = require 'async'

Tables = {}

Tables.actions = [
  r.tableCreate('actions')
  r.table('actions').indexCreate('card')
  r.table('actions').indexCreate('org')
  r.table('actions').indexCreate('stage')
]

Tables.cards = [
  r.tableCreate('cards')
  r.table('cards').indexCreate('actions', ((card) ->
    card('actions').keys()
      .map (key) -> card('actions')(key)
      .reduce (left, right) -> left.default([]).setUnion(right)
  ), {multi: true})
  r.table('cards').indexCreate('org')
  r.table('cards').indexCreate('stack')
]

Tables.goals = [
  r.tableCreate('goals')
  r.table('goals').indexCreate('org')
]

Tables.kinds = [
  r.tableCreate('kinds')
  r.table('kinds').indexCreate('org')
]

Tables.notes = [
  r.tableCreate('notes')
  r.table('notes').indexCreate('card')
  r.table('notes').indexCreate('org')
  r.table('notes').indexCreate('user')
]

Tables.orgs = [
  r.tableCreate('orgs')
  r.table('orgs').indexCreate('leaders', {multi: true})
  r.table('orgs').indexCreate('members', {multi: true})
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

Tables.users = [
  r.tableCreate('users')
  r.table('users').indexCreate('emails', {multi: true})
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
