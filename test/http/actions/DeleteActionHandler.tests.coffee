expect              = require('chai').expect
TestData            = require 'test/framework/TestData'
TestHarness         = require 'test/framework/TestHarness'
DeleteActionHandler = require 'apps/api/handlers/actions/DeleteActionHandler'

describe 'actions:DeleteActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(DeleteActionHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['actions', 'checklists', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, actionid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid    = 'doesnotexist'
    actionid = 'action-takedbaby'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->

    orgid    = 'org-paddys'
    actionid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid action in an org of which the requester is a member', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'

    it 'deletes the action', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.id).to.equal(actionid)
        expect(action.status).to.equal('Deleted')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid    = 'org-sudz'
    actionid = 'action-ringbell'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and actionid', ->

    orgid    = 'org-paddys'
    actionid = 'action-ringbell'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
