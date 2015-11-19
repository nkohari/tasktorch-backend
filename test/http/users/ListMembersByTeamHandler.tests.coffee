_                        = require 'lodash'
expect                   = require('chai').expect
TestHarness              = require 'test/framework/TestHarness'
ListMembersByTeamHandler = require 'apps/api/handlers/users/ListMembersByTeamHandler'

describe 'users:ListMembersByTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMembersByTeamHandler, 'user-charlie')
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

    it 'returns an array of users that are members of the team', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {users} = res.result
        expect(users).to.exist
        expect(users).to.have.length(5)
        expect(_.pluck(users, 'id')).to.have.members ['user-charlie', 'user-dee', 'user-dennis', 'user-frank', 'user-mac']
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
