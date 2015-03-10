_     = require 'lodash'
async = require 'async'
r     = require 'rethinkdb'

table = (records) ->
  _.object _.map records, (r) -> [r.id, r]

record = (data) ->
  _.extend {status: 'Normal', version: 0}, data

TestData = {dbname: 'torchtest'}

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
  record {
    id:     'action-ringbell'
    org:    'org-sudz'
    card:   'card-ringbell'
    stage:  'stage-task-do'
    text:   'Ring the bell'
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
    user:      null
    team:      'team-thegang'
    stack:     'stack-thegang-inbox'
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
    followers: ['user-dennis', 'user-mac']
    kind:      'kind-scheme'
    goal:      'goal-gascrisis'
    title:     'Buy a shitload of gas'
    summary:   'We need to buy a shitload of gasoline'
    user:      'user-mac'
    team:      null
    stack:     'user-mac-queue'
    moves:     []
    actions:
      'stage-scheme-plan':  []
      'stage-scheme-do':    []
      'stage-scheme-drink': []
  }
  record {
    id:        'card-boildenim'
    org:       'org-paddys'
    creator:   'user-charlie'
    followers: ['user-charlie', 'user-frank']
    kind:      'kind-scheme'
    title:     'Boil Denim'
    summary:   '4 denim chiken?'
    user:      null
    team:      'team-gruesometwosome'
    stack:     'stack-gruesometwosome-plans'
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
    user:      'user-greg'
    team:      null
    stack:     'user-greg-queue'
    moves:     []
    actions:
      'stage-task-do': ['action-ringbell']
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
  record {
    id:    "stack-charlie-dreams"
    org:   'org-paddys'
    type:  'Backlog'
    name:  'Dreams'
    user:  'user-charlie'
    cards: []
  }
  # Dee
  record {
    id:    "stack-dee-inbox"
    org:   'org-paddys'
    type:  'Inbox'
    user:  'user-dee'
    cards: []
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
    id:    'stack-gruesometwosome-plans'
    org:   'org-paddys'
    type:  'Backlog'
    team:  'team-gruesometwosome'
    cards: ['card-boildenim']
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
    org:  'org-paddys'
    kind: 'kind-scheme'
    name: 'Plan'
  }
  record {
    id:   'stage-scheme-do'
    org:  'org-paddys'
    kind: 'kind-scheme'
    name: 'Execute'
  }
  record {
    id:   'stage-scheme-drink'
    org:  'org-paddys'
    kind: 'kind-scheme'
    name: 'Drink'
  }
  record {
    id:   'stage-task-do'
    org:  'org-sudz'
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

TestData.tokens = table [
  record {
    id:      'token-waitress'
    org:     'org-paddys'
    creator: 'user-charlie'
    comment: 'waitress@coffeeshop.com'
  }
  record {
    id:      'token-ricketycricket'
    creator: 'user-dennis'
    comment: 'rickety.cricket@underthebridge.com'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.users = table [
  record {
    id:       'user-charlie'
    name:     'Charlie Kelly'
    username: 'dayman'
    emails:   ['charlie.kelly@paddyspub.com']
    # waitress
    password: 'c2NyeXB0AA4AAAAIAAAAAaF626neJ1gQrqKS+qkxcpMNQd76mLpkXQhjyZEAKhJjAstfoKlh4dnncpN4Oaurq6ebVGo6n9sEK/Z4gVMI6eqPsYt3NEZBcwfnU4Ud/QxZ'
  }
  record {
    id:       'user-mac'
    name:     'Mac'
    username: 'mac'
    emails:   ['ronald.mcdonald@paddyspub.com']
    # badass
    password: 'c2NyeXB0AA4AAAAIAAAAAY6zpclMXNqwYpx5vlyOJIy4k4bMFIcZbEOKjyTorYSJeFtAgK0mYiehWJxY/5AtWdcxudDB7TJELSueYwl9Ky03mdTWyHC5c+tmxsEU3xSc'
  }
  record {
    id:       'user-dee'
    name:     'Dee Reynolds'
    username: 'sweetdee'
    emails:   ['dee.reynolds@paddyspub.com']
    # joshgroban
    password: 'c2NyeXB0AA4AAAAIAAAAAUydbuvH6huaxIkHP7IHtDpPhU2qUdUEivMAd37WoQn2ad2txXL/364gi0YpWPCU5hSMukKyT7jDTZHkVSIu4ezWfVrTH2+6fGm2eEGCfmbU'
  }
  record {
    id:       'user-dennis'
    name:     'Dennis Reynolds'
    username: '80srockgod'
    emails:   ['dennis.reynolds@paddyspub.com']
    # dennis
    password: 'c2NyeXB0AA4AAAAIAAAAAQ4/0t2PcxibqPK17NrzpZ6bX2Get+e0XVZNTn23M/L51pufBCroXLQfXhjjCdaU4zvvDqBap6/+8sQWT7jLTrzkLnwDYbBUCbzzWZ4zPuOd'
  }
  record {
    id:       'user-frank'
    name:     'Frank Reynolds'
    username: 'mantis'
    emails:   ['frank.reynolds@paddyspub.com']
    # egg
    password: 'c2NyeXB0AA4AAAAIAAAAATBPGguuUu+9+SPHFnUREJBwzVMxP1rVV3kePeHwLvpZq9urXoQtdsRft4bGugZV/6lgNBlDHjrpjHo52MD7XjiujEnfYNv5lgspeH9ptIyj'
  }
  record {
    id:       'user-greg'
    name:     'Greg'
    username: 'greg'
    emails:   ['greg@sudz.com']
    # maxwell
    password: 'c2NyeXB0AA4AAAAIAAAAAWvXMRsISN9AyD9y/vLE9MVZvCn0KDUlbr3wBg8FrFHQoMSSO2G3Updhru9hD+cyyGmH69idaSeXJu49x06t55YJeANMFbdOaCMQwRuf+Vkd'
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
  'tokens'
  'users'
]

#---------------------------------------------------------------------------------------------------

runBatch = (statements, callback) ->
  r.connect {db: TestData.dbname}, (err, conn) ->
    return callback(err) if err?
    async.eachSeries statements, ((statement, next) -> statement.run(conn, next)), callback

TestData.clear = (tables, callback) ->
  statements = _.map tables, (name) -> r.table(name).delete()
  runBatch(statements, callback)

TestData.populate = (tables, callback) ->
  statements = _.map tables, (name) -> r.table(name).insert _.values(TestData[name])
  runBatch(statements, callback)

TestData.reset = (tables, callback) ->
  TestData.clear tables, (err) ->
    return callback(err) if err?
    TestData.populate tables, (err) ->
      return callback(err) if err?
      callback()

module.exports = TestData
