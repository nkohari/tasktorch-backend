_                             = require 'lodash'
expect                        = require('chai').expect
TestHarness                   = require 'test/framework/TestHarness'
ListActionsByChecklistHandler = require 'apps/api/handlers/actions/ListActionsByChecklistHandler'

describe 'actions:ListActionsByChecklistHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListActionsByChecklistHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-takedbaby-do'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, checklistid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid       = 'org-oldiesrockcafe'
    checklistid = 'checklist-takedbaby-do'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, checklistid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid       = 'doesnotexist'
    checklistid = 'checklist-takedbaby-do'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid       = 'org-paddys'
    checklistid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid checklist in an org of which the requester is a member', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-takedbaby-do'

    it 'returns an array of actions in the checklist', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {actions} = res.result
        expect(actions).to.exist
        expect(actions).to.have.length(2)
        expect(_.pluck(actions, 'id')).to.have.members ['action-takedbaby', 'action-meetwaitress']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid       = 'org-sudz'
    checklistid = 'checklist-ringbell-do'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and checklistid', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-ringbell-do'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
