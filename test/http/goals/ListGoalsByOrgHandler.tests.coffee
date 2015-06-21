_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
CommonBehaviors       = require 'test/framework/CommonBehaviors'
ListGoalsByOrgHandler = require 'apps/api/handlers/goals/ListGoalsByOrgHandler'

describe 'ListGoalsByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListGoalsByOrgHandler)
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
    it 'returns an array of goals defined for the org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {goals} = res.result
        expect(goals).to.exist()
        expect(goals).to.have.length(2)
        expect(_.pluck(goals, 'id')).to.have.members ['goal-streetfighter', 'goal-gascrisis']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
