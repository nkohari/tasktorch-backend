_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
DeleteTeamHandler = require 'apps/api/handlers/teams/DeleteTeamHandler'

describe 'DeleteTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(DeleteTeamHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['teams'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', teamid: 'team-gruesometwosome'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid  = 'doesnotexist'
    teamid = 'team-gruesometwosome'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent team', ->
    orgid  = 'org-paddys'
    teamid = 'doesnotexist'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid team in an org of which the requester is a member', ->
    orgid  = 'org-paddys'
    teamid = 'team-gruesometwosome'
    it "sets the team's status to Deleted", (done) ->
      @tester.request {orgid, teamid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team).to.exist()
        expect(team.id).to.equal(teamid)
        expect(team.status).to.equal('Deleted')
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid  = 'org-sudz'
    teamid = 'team-sudz'
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, teamid, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and teamid', ->
    orgid  = 'org-paddys'
    teamid = 'team-sudz'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
