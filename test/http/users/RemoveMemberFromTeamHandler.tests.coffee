_                           = require 'lodash'
expect                      = require('chai').expect
TestHarness                 = require 'test/framework/TestHarness'
RemoveMemberFromTeamHandler = require 'apps/api/handlers/users/RemoveMemberFromTeamHandler'

describe 'users:RemoveMemberFromTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(RemoveMemberFromTeamHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['teams'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'
    userid = 'user-frank'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, teamid, userid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    teamid = 'team-thegang'
    userid = 'user-frank'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, teamid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a user who is not a member of the team', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'
    userid = 'user-greg'

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, teamid, userid}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a user who is a member of the team but not a leader', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'
    userid = 'user-dee'

    it 'removes the user as a member', (done) ->
      @tester.request {orgid, teamid, userid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team.id).to.equal(teamid)
        expect(team.members).to.be.an('array')
        expect(team.members).not.to.contain(userid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is both a member and a leader of the org', ->

    orgid  = 'org-paddys'
    teamid = 'team-thegang'
    userid = 'user-mac'

    it 'removes the user as a member and a leader', (done) ->
      @tester.request {orgid, teamid, userid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team.id).to.equal(teamid)
        expect(team.leaders).to.be.an('array')
        expect(team.leaders).not.to.contain(userid)
        expect(team.members).to.be.an('array')
        expect(team.members).not.to.contain(userid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    teamid = 'team-sudz'
    userid = 'user-greg'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, teamid, userid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
