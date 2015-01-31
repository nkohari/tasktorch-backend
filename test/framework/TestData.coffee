_     = require 'lodash'
async = require 'async'
r     = require 'rethinkdb'

table = (records) ->
  _.object _.map records, (r) -> [r.id, r]

record = (data) ->
  _.extend {status: 'Normal', version: 0}, data

TestData = {}

#---------------------------------------------------------------------------------------------------

TestData.actions = table [
  record {
    id:     'action-takedbaby'
    org:    'org-paddys'
    card:   'card-takedbaby'
    stage:  'stage-scheme-do'
    text:   'Taked the baby'
    status: 'Complete'
  }
  record {
    id:     'action-meetwaitress'
    org:    'org-paddys'
    card:   'card-takedbaby'
    stage:  'stage-scheme-do'
    text:   'Meet waitress at coffee shop'
    status: 'Warning'
  }
  record {
    id:     'action-meetatlaterbar'
    org:    'org-paddys'
    card:   'card-takedbaby'
    stage:  'stage-scheme-do'
    text:   'Meet Mac and Dee at later bar'
    status: 'NotStarted'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.cards = table [
  record {
    id:        'card-takedbaby'
    org:       'org-paddys'
    creator:   'user-charlie'
    followers: ['user-charlie', 'user-dee', 'user-mac']
    kind:      'kind-scheme'
    title:     'Taked baby'
    summary:   'Meet at later bar, day or night, sometime'
    owner:     'user-dee'
    stack:     'user-dee-inbox'
    moves:     []
    actions:
      'stage-scheme-plan':  []
      'stage-scheme-do':    ['action-takedbaby', 'action-meetwaitress']
      'stage-scheme-drink': ['action-meetatlaterbar']
  }
  record {
    id:        'card-buygas'
    org:       'org-paddys'
    creator:   'user-mac'
    followers: ['user-charlie', 'user-dennis', 'user-mac']
    kind:      'kind-scheme'
    goal:      'goal-gascrisis'
    title:     'Buy a shitload of gas'
    summary:   'We need to buy a shitload of gasoline'
    owner:     'user-mac'
    stack:     'user-mac-queue'
    moves:     []
    actions:
      'stage-scheme-plan':  []
      'stage-scheme-do':    []
      'stage-scheme-drink': []
  }
  record {
    id:        'card-ringbell'
    org:       'org-sudz'
    creator:   'user-greg'
    followers: ['user-greg']
    kind:      'kind-task'
    title:     'Ring the bell so everyone drinks'
    summary:   'AND REMEMBER TO KEEP SMILING'
    owner:     'user-greg'
    stack:     'user-greg-queue'
    moves:     []
    actions:
      'stage-task-do': []
  }
]

#---------------------------------------------------------------------------------------------------

TestData.goals = table [
  record {
    id:   'goal-streetfighter'
    org:  'org-paddys'
    name: 'Make Charlie into a street fighter'
  }
  record {
    id:   'goal-gascrisis'
    org:  'org-paddys'
    name: 'Solve the gas crisis'
  }
  record {
    id:   'goal-winawards'
    org:  'org-sudz'
    name: 'Win as many awards as possible'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.kinds = table [
  record {
    id:     'kind-scheme'
    org:    'org-paddys'
    name:   'Scheme'
    color:  '#999999'
    stages: ['stage-scheme-plan', 'stage-scheme-do', 'stage-scheme-drink']
  }
  record {
    id:     'kind-task'
    org:    'org-sudz'
    name:   'Task'
    color:  '#999999'
    stages: ['stage-task-do']
  }
]

#---------------------------------------------------------------------------------------------------

TestData.notes = table [
  record {
    id:      'note-1'
    org:     'org-paddys'
    card:    'card-takedbaby'
    type:    'CardCreated'
    time:    Date.UTC(2015, 1, 15)
    user:    'user-charlie'
  }
  record {
    id:      'note-2'
    org:     'org-paddys'
    card:    'card-takedbaby'
    type:    'CardPassed'
    time:    Date.UTC(2015, 1, 15)
    user:    'user-charlie'
    content:
      from: {user: 'user-charlie', stack: 'stack-charlie-drafts'}
      to:   {user: 'user-dee',     stack: 'stack-dee-inbox'}
  }
]

#---------------------------------------------------------------------------------------------------

TestData.orgs = table [
  record {
    id:      'org-paddys'
    name:    "Paddy's Pub"
    members: ['user-charlie', 'user-mac', 'user-dee', 'user-dennis', 'user-frank']
    leaders: ['user-mac', 'user-dennis', 'user-frank']
  }
  record {
    id:      'org-sudz'
    name:    'Sudz'
    members: ['user-greg']
    leaders: []
  }
]

#---------------------------------------------------------------------------------------------------

TestData.stacks = table [
  # Charlie
  record {
    id:    "stack-charlie-inbox"
    org:   'org-paddys'
    type:  'Inbox'
    user:  'user-charlie'
    cards: []
  }
  record {
    id:    "stack-charlie-queue"
    org:   'org-paddys'
    type:  'Queue'
    user:  'user-charlie'
    cards: []
  }
  record {
    id:    "stack-charlie-drafts"
    org:   'org-paddys'
    type:  'Drafts'
    user:  'user-charlie'
    cards: []
  }
  # Dee
  record {
    id:    "stack-dee-inbox"
    org:   'org-paddys'
    type:  'Inbox'
    user:  'user-dee'
    cards: ['card-takedbaby']
  }
  record {
    id:    "stack-dee-queue"
    org:   'org-paddys'
    type:  'Queue'
    user:  'user-dee'
    cards: []
  }
  record {
    id:    "stack-dee-drafts"
    org:   'org-paddys'
    type:  'Drafts'
    user:  'user-dee'
    cards: []
  }
  # Dennis
  record {
    id:    "stack-dennis-inbox"
    org:   'org-paddys'
    type:  'Inbox'
    user:  'user-dennis'
    cards: []
  }
  record {
    id:    "stack-dennis-queue"
    org:   'org-paddys'
    type:  'Queue'
    user:  'user-dennis'
    cards: []
  }
  record {
    id:    "stack-dennis-drafts"
    org:   'org-paddys'
    type:  'Drafts'
    user:  'user-dennis'
    cards: []
  }
  # Frank
  record {
    id:    "stack-frank-inbox"
    org:   'org-paddys'
    type:  'Inbox'
    user:  'user-frank'
    cards: []
  }
  record {
    id:    "stack-frank-queue"
    org:   'org-paddys'
    type:  'Queue'
    user:  'user-frank'
    cards: []
  }
  record {
    id:    "stack-frank-drafts"
    org:   'org-paddys'
    type:  'Drafts'
    user:  'user-frank'
    cards: []
  }
  # Mac
  record {
    id:    "stack-mac-inbox"
    org:   'org-paddys'
    type:  'Inbox'
    user:  'user-mac'
    cards: []
  }
  record {
    id:    "stack-mac-queue"
    org:   'org-paddys'
    type:  'Queue'
    user:  'user-mac'
    cards: ['card-buygas']
  }
  record {
    id:    "stack-mac-drafts"
    org:   'org-paddys'
    type:  'Drafts'
    user:  'user-mac'
    cards: []
  }
  # Greg
  record {
    id:    "stack-greg-inbox"
    org:   'org-sudz'
    type:  'Inbox'
    user:  'user-greg'
    cards: ['card-takedbaby']
  }
  record {
    id:    "stack-greg-queue"
    org:   'org-sudz'
    type:  'Queue'
    user:  'user-greg'
    cards: ['card-ringbell']
  }
  record {
    id:    "stack-greg-drafts"
    org:   'org-sudz'
    type:  'Drafts'
    user:  'user-greg'
    cards: []
  }
  # Teams
  record {
    id:    'stack-thegang-inbox'
    org:   'org-paddys'
    type:  'Inbox'
    team:  'team-thegang'
    cards: ['card-taked-baby']
  }
  record {
    id:    'stack-dynamicduo-inbox'
    org:   'org-paddys'
    type:  'Inbox'
    team:  'team-dynamicduo'
    cards: []
  }
  record {
    id:    'stack-gruesometwosome-inbox'
    org:   'org-paddys'
    type:  'Inbox'
    team:  'team-gruesometwosome'
    cards: []
  }
  record {
    id:    'stack-sudz-inbox'
    org:   'org-sudz'
    type:  'Inbox'
    team:  'team-sudz'
    cards: []
  }
]

#---------------------------------------------------------------------------------------------------

TestData.stages = [
  record {
    id:   'stage-scheme-plan'
    kind: 'kind-scheme'
    name: 'Plan'
  }
  record {
    id:   'stage-scheme-do'
    kind: 'kind-scheme'
    name: 'Execute'
  }
  record {
    id:   'stage-scheme-drink'
    kind: 'kind-scheme'
    name: 'Drink'
  }
  record {
    id:   'stage-task-do'
    kind: 'kind-task'
    name: 'Do'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.teams = table [
  record {
    id:      'team-thegang'
    org:     'org-paddys'
    name:    'The Gang'
    members: ['user-charlie', 'user-mac', 'user-dee', 'user-dennis', 'user-frank']
    leaders: ['user-mac', 'user-dennis', 'user-frank']
  }
  record {
    id:      'team-dynamicduo'
    org:     'org-paddys'
    name:    'The Dynamic Duo'
    members: ['user-dennis', 'user-mac']
    leaders: ['user-mac']
  }
  record {
    id:      'team-gruesometwosome'
    org:     'org-paddys'
    name:    'Gruesome Twosome'
    members: ['user-charlie', 'user-frank']
    leaders: ['user-charlie', 'user-frank']
  }
  record {
    id:      'team-sudz'
    org:     'org-sudz'
    name:    'Sudz Staff'
    members: ['user-greg']
    leaders: []
  }
]

#---------------------------------------------------------------------------------------------------

TestData.users = table [
  {
    id:       'user-charlie'
    name:     'Charlie Kelly'
    username: 'dayman'
    emails:   ['charlie.kelly@paddyspub.com']
  }
  {
    id:       'user-mac'
    name:     'Mac'
    username: 'mac'
    emails:   ['ronald.mcdonald@paddyspub.com']
  }
  {
    id:       'user-dee'
    name:     'Dee Reynolds'
    username: 'sweetdee'
    emails:   ['dee.reynolds@paddyspub.com']
  }
  {
    id:       'user-dennis'
    name:     'Dennis Reynolds'
    username: '80srockgod'
    emails:   ['dennis.reynolds@paddyspub.com']
  }
  {
    id:       'user-frank'
    name:     'Frank Reynolds'
    username: 'mantis'
    emails:   ['frank.reynolds@paddyspub.com']
  }
  {
    id:       'user-greg'
    name:     'Greg'
    username: 'greg'
    emails:   ['greg@sudz.com']
  }
]

#---------------------------------------------------------------------------------------------------

TestData.tables = [
  'actions'
  'cards'
  'goals'
  'kinds'
  'notes'
  'orgs'
  'sessions'
  'stacks'
  'stages'
  'teams'
  'users'
]

#---------------------------------------------------------------------------------------------------

runBatch = (dbname, statements, callback) ->
  r.connect {db: dbname}, (err, conn) ->
    return callback(err) if err?
    async.eachSeries statements, ((statement, next) -> statement.run(conn, next)), callback

TestData.clear = (dbname, callback) ->
  statements = _.map TestData.tables, (name) -> r.table(name).delete()
  runBatch(dbname, statements, callback)

TestData.populate = (dbname, callback) ->
  statements = _.map TestData.tables, (name) -> r.table(name).insert _.values(TestData[name])
  runBatch(dbname, statements, callback)

TestData.reset = (dbname, callback) ->
  TestData.clear dbname, (err) ->
    return callback(err) if err?
    TestData.populate dbname, (err) ->
      return callback(err) if err?
      callback()

module.exports = TestData