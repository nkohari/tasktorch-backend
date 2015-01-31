_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
CommonBehaviors         = require 'test/framework/CommonBehaviors'
ListStagesByKindHandler = require 'http/handlers/stages/ListStagesByKindHandler'

describe 'ListStagesByKindHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListStagesByKindHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', kindid: 'kind-scheme'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', kindid: 'kind-scheme', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent kind', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', kindid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid kind in an org of which the requester is a member', ->
    it 'returns an array of stages belonging to the kind', (done) ->
      @tester.request {orgid: 'org-paddys', kindid: 'kind-scheme', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {stages} = res.body
        expect(stages).to.exist()
        expect(stages).to.have.length(3)
        expect(_.pluck(stages, 'id')).to.have.members ['stage-scheme-plan', 'stage-scheme-do', 'stage-scheme-drink']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', kindid: 'kind-task', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and kindid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', kindid: 'kind-task', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
