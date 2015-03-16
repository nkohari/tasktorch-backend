_                   = require 'lodash'
expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
CommonBehaviors     = require 'test/framework/CommonBehaviors'
GetChecklistHandler = require 'http/handlers/checklists/GetChecklistHandler'

describe 'GetChecklistHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetChecklistHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', checklistid: 'checklist-takedbaby-do'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', checklistid: 'checklist-takedbaby-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent checklist', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', checklistid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid checklist in an org of which the requester is a member', ->
    it 'returns the checklist', (done) ->
      @tester.request {orgid: 'org-paddys', checklistid: 'checklist-takedbaby-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {checklist} = res.result
        expect(checklist).to.exist()
        expect(checklist.id).to.equal('checklist-takedbaby-do')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', checklistid: 'checklist-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and checklistid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', checklistid: 'checklist-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
