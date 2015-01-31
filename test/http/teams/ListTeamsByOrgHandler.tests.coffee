_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
CommonBehaviors       = require 'test/framework/CommonBehaviors'
ListTeamsByOrgHandler = require 'http/handlers/teams/ListTeamsByOrgHandler'

describe 'ListTeamsByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListTeamsByOrgHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->
    it 'returns an array of teams belonging to the org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {teams} = res.body
        expect(teams).to.exist()
        expect(teams).to.have.length(3)
        expect(_.pluck(teams, 'id')).to.have.members ['team-thegang', 'team-dynamicduo', 'team-gruesometwosome']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a suggest parameter', ->
    it 'returns an array of teams whose names begin with the specified value', (done) ->
      @tester.request {orgid: 'org-paddys', query: {suggest: 'g'}, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {teams} = res.body
        expect(teams).to.exist()
        expect(teams).to.have.length(1)
        expect(_.pluck(teams, 'id')).to.have.members ['team-gruesometwosome']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
