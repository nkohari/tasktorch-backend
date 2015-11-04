_                      = require 'lodash'
expect                 = require('chai').expect
TestHarness            = require 'test/framework/TestHarness'
CreateTeamStackHandler = require 'apps/api/handlers/stacks/CreateTeamStackHandler'

describe 'stacks:CreateTeamStackHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateTeamStackHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['stacks'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, teamid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    teamid  = 'team-thegang'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent team', ->

    orgid   = 'org-paddys'
    teamid  = 'doesnotexist'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->

    orgid   = 'org-paddys'
    teamid  = 'team-thegang'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null name argument', ->

    orgid   = 'org-paddys'
    teamid  = 'team-thegang'
    payload = {name: null}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid name argument', ->

    orgid   = 'org-paddys'
    teamid  = 'team-thegang'
    payload = {name: new Date().valueOf().toString()}

    it 'creates and returns a backlog stack owned by the team', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {stack} = res.result
        expect(stack.name).to.equal(payload.name)
        expect(stack.team).to.equal(teamid)
        expect(stack.type).to.equal('Backlog')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    teamid  = 'team-sudz'
    payload = {name: 'Test'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and teamid', ->

    orgid   = 'org-paddys'
    teamid  = 'team-sudz'
    payload = {name: 'Test'}
    
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
