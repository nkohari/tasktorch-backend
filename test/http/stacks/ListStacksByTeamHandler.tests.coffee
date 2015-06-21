_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
CommonBehaviors         = require 'test/framework/CommonBehaviors'
ListStacksByTeamHandler = require 'apps/api/handlers/stacks/ListStacksByTeamHandler'

describe 'ListStacksByTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListStacksByTeamHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', teamid: 'team-gruesometwosome'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', teamid: 'team-gruesometwosome', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent team', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', teamid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid team in an org of which the requester is a member', ->
    it 'returns an array of stacks belonging to the team', (done) ->
      @tester.request {orgid: 'org-paddys', teamid: 'team-gruesometwosome', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {stacks} = res.result
        expect(stacks).to.exist()
        expect(stacks).to.have.length(2)
        expect(_.pluck(stacks, 'id')).to.have.members ['stack-gruesometwosome-inbox', 'stack-gruesometwosome-plans']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', teamid: 'team-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and teamid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', teamid: 'team-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
