_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
GetTeamHandler  = require 'apps/api/handlers/teams/GetTeamHandler'

describe 'teams:GetTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetTeamHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, teamid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid  = 'org-oldiesrockcafe'
    teamid = 'team-thegang'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, teamid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    teamid = 'team-thegang'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent team', ->

    orgid  = 'org-paddys'
    teamid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid team in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'

    it 'returns the team', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {team} = res.result
        expect(team).to.exist
        expect(team.id).to.equal(teamid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    teamid = 'team-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and teamid', ->

    orgid  = 'org-paddys'
    teamid = 'team-sudz'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
