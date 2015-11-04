_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
ChangeTeamNameHandler = require 'apps/api/handlers/teams/ChangeTeamNameHandler'

describe 'teams:ChangeTeamNameHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeTeamNameHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['teams'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    teamid = 'team-gruesometwosome'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, teamid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    teamid  = 'team-gruesometwosome'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent stack', ->

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
    teamid  = 'team-gruesometwosome'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null name argument', ->

    orgid   = 'org-paddys'
    teamid  = 'team-gruesometwosome'
    payload = {name: null}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a team in an org of which the requester is a member', ->

    orgid   = 'org-paddys'
    teamid  = 'team-gruesometwosome'
    payload = {name: new Date().valueOf().toString()}

    it 'changes the name of the team', (done) ->
      @tester.request {orgid, teamid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team).to.exist()
        expect(team.id).to.equal(teamid)
        expect(team.name).to.equal(payload.name)
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
