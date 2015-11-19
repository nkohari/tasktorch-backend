expect                    = require('chai').expect
TestHarness               = require 'test/framework/TestHarness'
ChangeActionStatusHandler = require 'apps/api/handlers/actions/ChangeActionStatusHandler'

describe 'actions:ChangeActionStatusHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionStatusHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['actions', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, actionid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid    = 'org-oldiesrockcafe'
    actionid = 'action-takedbaby'
    payload  = {status: 'InProgress'}

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, actionid, payload}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid    = 'doesnotexist'
    actionid = 'action-takedbaby'
    payload  = {status: 'InProgress'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->

    orgid    = 'org-paddys'
    actionid = 'doesnotexist'
    payload  = {status: 'InProgress'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a status argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid status argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {status: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid status argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {status: 'InProgress'}

    it 'changes the status to the specified status', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.id).to.equal(actionid)
        expect(action.status).to.equal(payload.status)
        done()

#---------------------------------------------------------------------------------------------------
