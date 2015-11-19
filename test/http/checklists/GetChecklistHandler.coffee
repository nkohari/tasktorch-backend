_                   = require 'lodash'
expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
GetChecklistHandler = require 'apps/api/handlers/checklists/GetChecklistHandler'

describe 'checklists:GetChecklistHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetChecklistHandler, 'user-charlie')
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

  describe 'when called for a non-existent checklist', ->

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

    it 'returns the checklist', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {checklist} = res.result
        expect(checklist).to.exist
        expect(checklist.id).to.equal(checklistid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid       = 'org-sudz'
    checklistid = 'checklist-ringbell'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and checklistid', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-ringbell'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
