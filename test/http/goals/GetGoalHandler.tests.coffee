_              = require 'lodash'
expect         = require('chai').expect
TestHarness    = require 'test/framework/TestHarness'
GetGoalHandler = require 'apps/api/handlers/goals/GetGoalHandler'

describe 'goals:GetGoalHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetGoalHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    goalid = 'goal-gascrisis'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, goalid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    goalid = 'goal-gascrisis'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, goalid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent goal', ->

    orgid  = 'org-paddys'
    goalid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, goalid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid goal in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    goalid = 'goal-gascrisis'

    it 'returns the goal', (done) ->
      @tester.request {orgid, goalid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {goal} = res.result
        expect(goal).to.exist
        expect(goal.id).to.equal(goalid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    goalid = 'goal-winawards'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, goalid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and goalid', ->

    orgid  = 'org-paddys'
    goalid = 'goal-winawards'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, goalid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
