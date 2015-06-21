_                             = require 'lodash'
expect                        = require('chai').expect
TestHarness                   = require 'test/framework/TestHarness'
CommonBehaviors               = require 'test/framework/CommonBehaviors'
ListActionsByChecklistHandler = require 'apps/api/handlers/actions/ListActionsByChecklistHandler'

describe 'ListActionsByChecklistHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListActionsByChecklistHandler)
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

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', checklistid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid checklist in an org of which the requester is a member', ->
    it 'returns an array of actions in the checklist', (done) ->
      @tester.request {orgid: 'org-paddys', checklistid: 'checklist-takedbaby-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {actions} = res.result
        expect(actions).to.exist()
        expect(actions).to.have.length(2)
        expect(_.pluck(actions, 'id')).to.have.members ['action-takedbaby', 'action-meetwaitress']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', checklistid: 'checklist-ringbell-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and checklistid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', checklistid: 'checklist-ringbell-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
