_                 = require 'lodash'
expect            = require('chai').expect
TestHarness       = require 'test/framework/TestHarness'
CreateGoalHandler = require 'apps/api/handlers/goals/CreateGoalHandler'

describe 'goals:CreateGoalHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateGoalHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['goals'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid   = 'org-oldiesrockcafe'
    payload = {name: 'Test'}

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, payload}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->

    orgid   = 'org-paddys'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null name argument', ->

    orgid   = 'org-paddys'
    payload = {name: null}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with valid arguments for an org of which the requester is a member', ->

    orgid   = 'org-paddys'
    payload = {name: new Date().valueOf().toString()}

    it 'changes the name of the goal', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {goal} = res.result
        expect(goal).to.exist
        expect(goal.org).to.equal(orgid)
        expect(goal.name).to.equal(payload.name)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    payload = {name: 'Test'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()
        
#---------------------------------------------------------------------------------------------------
