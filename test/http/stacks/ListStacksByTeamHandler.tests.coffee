_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
ListStacksByTeamHandler = require 'apps/api/handlers/stacks/ListStacksByTeamHandler'

describe 'stacks:ListStacksByTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListStacksByTeamHandler, 'user-charlie')
      ready()

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

    orgid  = 'doesnotexist'
    teamid = 'team-gruesometwosome'

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
    teamid = 'team-gruesometwosome'

    it 'returns an array of stacks belonging to the team', (done) ->
      @tester.request {orgid, teamid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {stacks} = res.result
        expect(stacks).to.exist
        expect(stacks).to.have.length(2)
        expect(_.pluck(stacks, 'id')).to.have.members ['stack-gruesometwosome-inbox', 'stack-gruesometwosome-plans']
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
