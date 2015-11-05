_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
ListTeamsByOrgHandler = require 'apps/api/handlers/teams/ListTeamsByOrgHandler'

describe 'teams:ListTeamsByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListTeamsByOrgHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns an array of teams belonging to the org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {teams} = res.result
        expect(teams).to.exist
        expect(teams).to.have.length(3)
        expect(_.pluck(teams, 'id')).to.have.members ['team-thegang', 'team-dynamicduo', 'team-gruesometwosome']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a suggest parameter', ->

    orgid = 'org-paddys'
    query = {suggest: 'gru'}

    it 'returns an array of teams whose names begin with the specified value', (done) ->
      @tester.request {orgid, query}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {teams} = res.result
        expect(teams).to.exist
        expect(teams).to.have.length(1)
        expect(_.pluck(teams, 'id')).to.have.members ['team-gruesometwosome']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
