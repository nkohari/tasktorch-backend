_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
ListStagesByKindHandler = require 'apps/api/handlers/stages/ListStagesByKindHandler'

describe 'stages:ListStagesByKindHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListStagesByKindHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    kindid = 'kind-scheme'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, kindid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid  = 'org-oldiesrockcafe'
    kindid = 'kind-scheme'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, kindid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    kindid = 'kind-scheme'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, kindid}, (res) ->
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent kind', ->

    orgid  = 'org-paddys'
    kindid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, kindid}, (res) ->
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid kind in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    kindid = 'kind-scheme'

    it 'returns an array of stages belonging to the kind', (done) ->
      @tester.request {orgid, kindid}, (res) ->
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {stages} = res.result
        expect(stages).to.exist
        expect(stages).to.have.length(3)
        expect(_.pluck(stages, 'id')).to.have.members ['stage-scheme-plan', 'stage-scheme-do', 'stage-scheme-drink']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    kindid = 'kind-task'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, kindid}, (res) ->
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and kindid', ->

    orgid  = 'org-paddys'
    kindid = 'kind-task'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, kindid}, (res) ->
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
