_     = require 'lodash'
async = require 'async'
r     = require 'rethinkdb'

table = (records) ->
  _.object _.map records, (r) -> [r.id, r]

record = (data) ->
  _.extend {status: 'Normal', version: 0, created: new Date(), updated: new Date()}, data

TestData = {dbname: 'torchtest'}

#---------------------------------------------------------------------------------------------------

TestData.actions = table [
  record {
    id:        'action-takedbaby'
    org:       'org-paddys'
    card:      'card-takedbaby'
    checklist: 'checklist-takedbaby-do'
    stage:     'stage-scheme-do'
    status:    'Complete'
    text:      'Taked the baby'
  }
  record {
    id:        'action-meetwaitress'
    org:       'org-paddys'
    card:      'card-takedbaby'
    checklist: 'checklist-takedbaby-do'
    stage:     'stage-scheme-do'
    status:    'Warning'
    text:      'Meet waitress at coffee shop'
  }
  record {
    id:        'action-meetatlaterbar'
    org:       'org-paddys'
    card:      'card-takedbaby'
    checklist: 'checklist-takedbaby-drink'
    stage:     'stage-scheme-drink'
    status:    'NotStarted'
    text:      'Meet Mac and Dee at later bar'
  }
  record {
    id:         'action-ringbell'
    org:        'org-sudz'
    card:       'card-ringbell'
    checklist:  'checklist-ringbell-do'
    stage:      'stage-task-do'
    status:     'NotStarted'
    text:       'Ring the bell'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.cards = table [
  record {
    id:         'card-takedbaby'
    org:        'org-paddys'
    creator:    'user-charlie'
    followers:  ['user-charlie', 'user-mac']
    kind:       'kind-scheme'
    number:     1
    title:      'Taked baby'
    summary:    'Meet at later bar, day or night, sometime'
    user:       null
    team:       'team-thegang'
    stack:      'stack-thegang-inbox'
    stages:     ['stage-scheme-do', 'stage-scheme-drink']
    moves:      []
    checklists: ['checklist-takedbaby-plan', 'checklist-takedbaby-do', 'checklist-takedbaby-drink']
  }
  record {
    id:         'card-buygas'
    org:        'org-paddys'
    creator:    'user-mac'
    followers:  ['user-dennis', 'user-mac']
    kind:       'kind-scheme'
    number:     2
    goals:      ['goal-gascrisis']
    title:      'Buy a shitload of gas'
    summary:    'We need to buy a shitload of gasoline'
    user:       'user-mac'
    team:       null
    stack:      'user-mac-queue'
    stages:     []
    moves:      []
    checklists: ['checklist-buygas-plan', 'checklist-buygas-do', 'checklist-buygas-drink']
  }
  record {
    id:         'card-boildenim'
    org:        'org-paddys'
    creator:    'user-charlie'
    followers:  ['user-charlie', 'user-frank']
    kind:       'kind-scheme'
    number:     3
    title:      'Boil Denim'
    summary:    '4 denim chiken?'
    user:       null
    team:       'team-gruesometwosome'
    stack:      'stack-gruesometwosome-plans'
    stages:     []
    moves:      []
    checklists: ['checklist-boildenim-plan', 'checklist-boildenim-do', 'checklist-boildenim-drink']
  }
  record {
    id:         'card-ringbell'
    org:        'org-sudz'
    creator:    'user-greg'
    followers:  ['user-greg']
    kind:       'kind-task'
    number:     1
    title:      'Ring the bell so everyone drinks'
    summary:    'AND REMEMBER TO KEEP SMILING'
    user:       'user-greg'
    team:       null
    stack:      'user-greg-queue'
    stages:     ['stage-task-do']
    moves:      []
    checklists: ['checklist-ringbell-do']
  }
]

#---------------------------------------------------------------------------------------------------

TestData.checklists = table [
  # card-takedbaby
  record {
    id:      'checklist-takedbaby-plan'
    org:     'org-paddys'
    card:    'card-takedbaby'
    stage:   'stage-scheme-plan'
    actions: []
  }
  record {
    id:      'checklist-takedbaby-do'
    org:     'org-paddys'
    card:    'card-takedbaby'
    stage:   'stage-scheme-do'
    actions: ['action-takedbaby', 'action-meetwaitress']
  }
  record {
    id:      'checklist-takedbaby-drink'
    org:     'org-paddys'
    card:    'card-takedbaby'
    stage:   'stage-scheme-drink'
    actions: ['action-meetatlaterbar']
  }
  # card-buygas
  record {
    id:      'checklist-buygas-plan'
    org:     'org-paddys'
    card:    'card-buygas'
    stage:   'stage-scheme-plan'
    actions: []
  }
  record {
    id:      'checklist-buygas-do'
    org:     'org-paddys'
    card:    'card-buygas'
    stage:   'stage-scheme-do'
    actions: []
  }
  record {
    id:      'checklist-buygas-drink'
    org:     'org-paddys'
    card:    'card-buygas'
    stage:   'stage-scheme-drink'
    actions: []
  }
  # card-boildenim
  record {
    id:      'checklist-boildenim-plan'
    org:     'org-paddys'
    card:    'card-boildenim'
    stage:   'stage-scheme-plan'
    actions: []
  }
  record {
    id:      'checklist-boildenim-do'
    org:     'org-paddys'
    card:    'card-boildenim'
    stage:   'stage-scheme-do'
    actions: []
  }
  record {
    id:      'checklist-boildenim-drink'
    org:     'org-paddys'
    card:    'card-boildenim'
    stage:   'stage-scheme-drink'
    actions: []
  }
  # card-ringbell
  record {
    id:      'checklist-ringbell-do'
    org:     'org-sudz'
    card:    'card-ringbell'
    stage:   'stage-task-do'
    actions: ['action-ringbell']
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

TestData.invites = table [
  record {
    id:      'invite-waitress'
    org:     'org-paddys'
    creator: 'user-charlie'
    orgName: "Paddy's Pub"
    email:   'waitress@coffeeshop.com'
    level:   'Member'
    status:  'Pending'
  }
  record {
    id:      'invite-amanda'
    org:     'org-sudz'
    creator: 'user-greg'
    orgName: 'Sudz'
    email:   'amanda@sudz.com'
    level:   'Member'
    status:  'Pending'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.kinds = table [
  record {
    id:         'onboarding-kind'
    name:       'Onboarding Example'
    color:      'Blue'
    stages:     ['onboarding-stage-setup', 'onboarding-stage-learn', 'onboarding-stage-nextsteps']
    nextNumber: 0
  }
  record {
    id:         'kind-scheme'
    org:        'org-paddys'
    name:       'Scheme'
    color:      'Blue'
    stages:     ['stage-scheme-plan', 'stage-scheme-do', 'stage-scheme-drink']
    nextNumber: 4
  }
  record {
    id:         'kind-task'
    org:        'org-sudz'
    name:       'Task'
    color:      'Blue'
    stages:     ['stage-task-do']
    nextNumber: 2
  }
]

#---------------------------------------------------------------------------------------------------

TestData.notes = table [
  record {
    id:      'note-1'
    org:     'org-paddys'
    card:    'card-takedbaby'
    type:    'CardCreated'
    created: Date.UTC(2015, 1, 15)
    user:    'user-charlie'
  }
  record {
    id:      'note-2'
    org:     'org-paddys'
    card:    'card-takedbaby'
    type:    'CardPassed'
    created: Date.UTC(2015, 1, 15)
    user:    'user-charlie'
    content:
      from: {user: 'user-charlie', stack: 'stack-charlie-drafts'}
      to:   {user: 'user-dee',     stack: 'stack-dee-inbox'}
  }
]

#---------------------------------------------------------------------------------------------------

TestData.memberships = table [
  record {
    id:    'membership-paddys-charlie'
    user:  'user-charlie'
    org:   'org-paddys'
    level: 'Member'
  }
  record {
    id:    'membership-paddys-mac'
    user:  'user-mac'
    org:   'org-paddys'
    level: 'Leader'
  }
  record {
    id:    'membership-paddys-dee'
    user:  'user-dee'
    org:   'org-paddys'
    level: 'Member'
  }
  record {
    id:    'membership-paddys-dennis'
    user:  'user-dennis'
    org:   'org-paddys'
    level: 'Leader'
  }
  record {
    id:    'membership-paddys-frank'
    user:  'user-frank'
    org:   'org-paddys'
    level: 'Leader'
  }
  record {
    id:    'membership-sudz-greg'
    user:  'user-greg'
    org:   'org-sudz'
    level: 'Leader'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.orgs = table [
  record {
    id:   'org-paddys'
    name: "Paddy's Pub"
    account:
      subscription:
        status: 'Active'
  }
  record {
    id:   'org-sudz'
    name: 'Sudz'
    account:
      subscription:
        status: 'Active'
  }
  record {
    id:   'org-oldiesrockcafe'
    name: 'Oldies Rock Cafe'
    account:
      subscription:
        status: 'Canceled'
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
    cards: ['card-takedbaby']
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
    id:   'onboarding-stage-setup'
    kind: 'onboarding-kind'
    name: 'Setup'
  }
  record {
    id:   'onboarding-stage-learn'
    kind: 'onboarding-kind'
    name: 'Learn'
  }
  record {
    id:   'onboarding-stage-nextsteps'
    kind: 'onboarding-kind'
    name: 'Next Steps'
  }
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
    purpose: 'Scheming'
    members: ['user-charlie', 'user-mac', 'user-dee', 'user-dennis', 'user-frank']
    leaders: ['user-mac', 'user-dennis', 'user-frank']
  }
  record {
    id:      'team-dynamicduo'
    org:     'org-paddys'
    name:    'The Dynamic Duo'
    purpose: 'Movie Night'
    members: ['user-dennis', 'user-mac']
    leaders: ['user-mac']
  }
  record {
    id:      'team-gruesometwosome'
    org:     'org-paddys'
    name:    'Gruesome Twosome'
    purpose: 'Nightcrawlers'
    members: ['user-charlie', 'user-frank']
    leaders: ['user-charlie', 'user-frank']
  }
  record {
    id:      'team-sudz'
    org:     'org-sudz'
    name:    'Sudz Staff'
    purpose: 'Winning awards'
    members: ['user-greg']
    leaders: []
  }
]

#---------------------------------------------------------------------------------------------------

TestData.tokens = table [
  record {
    id:      'token-ricketycricket'
    creator: 'user-dennis'
    comment: 'rickety.cricket@underthebridge.com'
    status:  'Pending'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.users = table [
  record {
    id:       'user-charlie'
    name:     'Charlie Kelly'
    username: 'dayman'
    email :   'charlie.kelly@paddyspub.com'
    # waitress
    password: 'c2NyeXB0AA4AAAAIAAAAAaF626neJ1gQrqKS+qkxcpMNQd76mLpkXQhjyZEAKhJjAstfoKlh4dnncpN4Oaurq6ebVGo6n9sEK/Z4gVMI6eqPsYt3NEZBcwfnU4Ud/QxZ'
  }
  record {
    id:       'user-mac'
    name:     'Mac'
    username: 'mac'
    email:    'ronald.mcdonald@paddyspub.com'
    # badass
    password: 'c2NyeXB0AA4AAAAIAAAAAY6zpclMXNqwYpx5vlyOJIy4k4bMFIcZbEOKjyTorYSJeFtAgK0mYiehWJxY/5AtWdcxudDB7TJELSueYwl9Ky03mdTWyHC5c+tmxsEU3xSc'
  }
  record {
    id:       'user-dee'
    name:     'Dee Reynolds'
    username: 'sweetdee'
    email:    'dee.reynolds@paddyspub.com'
    # joshgroban
    password: 'c2NyeXB0AA4AAAAIAAAAAUydbuvH6huaxIkHP7IHtDpPhU2qUdUEivMAd37WoQn2ad2txXL/364gi0YpWPCU5hSMukKyT7jDTZHkVSIu4ezWfVrTH2+6fGm2eEGCfmbU'
  }
  record {
    id:       'user-dennis'
    name:     'Dennis Reynolds'
    username: '80srockgod'
    email:    'dennis.reynolds@paddyspub.com'
    # dennis
    password: 'c2NyeXB0AA4AAAAIAAAAAQ4/0t2PcxibqPK17NrzpZ6bX2Get+e0XVZNTn23M/L51pufBCroXLQfXhjjCdaU4zvvDqBap6/+8sQWT7jLTrzkLnwDYbBUCbzzWZ4zPuOd'
  }
  record {
    id:       'user-frank'
    name:     'Frank Reynolds'
    username: 'mantis'
    email:    'frank.reynolds@paddyspub.com'
    # egg
    password: 'c2NyeXB0AA4AAAAIAAAAATBPGguuUu+9+SPHFnUREJBwzVMxP1rVV3kePeHwLvpZq9urXoQtdsRft4bGugZV/6lgNBlDHjrpjHo52MD7XjiujEnfYNv5lgspeH9ptIyj'
  }
  record {
    id:       'user-greg'
    name:     'Greg'
    username: 'greg'
    email:    'greg@sudz.com'
    # maxwell
    password: 'c2NyeXB0AA4AAAAIAAAAAWvXMRsISN9AyD9y/vLE9MVZvCn0KDUlbr3wBg8FrFHQoMSSO2G3Updhru9hD+cyyGmH69idaSeXJu49x06t55YJeANMFbdOaCMQwRuf+Vkd'
  }
]

#---------------------------------------------------------------------------------------------------

TestData.tables = [
  'actions'
  'cards'
  'checklists'
  'goals'
  'invites'
  'kinds'
  'notes'
  'memberships'
  'orgs'
  'sessions'
  'stacks'
  'stages'
  'teams'
  'tokens'
  'users'
]

#---------------------------------------------------------------------------------------------------

runBatch = (conn, statements, callback) ->
  runStatement = (statement, next) ->
    statement.run(conn, next)
  async.eachSeries(statements, runStatement, callback)

TestData.clear = (conn, tables, callback) ->
  statements = _.map tables, (name) -> r.table(name).delete()
  runBatch(conn, statements, callback)

TestData.populate = (conn, tables, callback) ->
  statements = _.map tables, (name) -> r.table(name).insert _.values(TestData[name])
  runBatch(conn, statements, callback)

TestData.reset = (conn, tables, callback) ->
  TestData.clear conn, tables, (err) ->
    return callback(err) if err?
    TestData.populate conn, tables, (err) ->
      return callback(err) if err?
      callback()

module.exports = TestData
