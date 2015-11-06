_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
ChangeGoalNameHandler = require 'apps/api/handlers/goals/ChangeGoalNameHandler'

describe 'goals:ChangeGoalNameHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeGoalNameHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['goals'], done

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

    orgid   = 'doesnotexist'
    goalid  = 'goal-gascrisis'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent goal', ->

    orgid   = 'org-paddys'
    goalid  = 'doesnotexist'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->

    orgid   = 'org-paddys'
    goalid  = 'goal-gascrisis'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null name argument', ->

    orgid   = 'org-paddys'
    goalid  = 'goal-gascrisis'
    payload = {name: null}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid goal in an org of which the requester is a member', ->

    orgid   = 'org-paddys'
    goalid  = 'goal-gascrisis'
    payload = {name: new Date().valueOf().toString()}

    it 'changes the name of the goal', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {goal} = res.result
        expect(goal).to.exist
        expect(goal.id).to.equal(goalid)
        expect(goal.name).to.equal(payload.name)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    goalid  = 'goal-winawards'
    payload = {name: 'Test'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and goalid', ->

    orgid   = 'org-paddys'
    goalid  = 'goal-winawards'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, goalid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
