_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
ListCardsByStageHandler = require 'apps/api/handlers/cards/ListCardsByStageHandler'

describe 'cards:ListCardsByStageHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListCardsByStageHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid   = 'org-paddys'
    stageid = 'stage-scheme-do'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, stageid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    stageid = 'stage-scheme-do'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stageid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent stage', ->

    orgid   = 'org-paddys'
    stageid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stageid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid stage in an org of which the requester is a member', ->

    orgid   = 'org-paddys'
    stageid = 'stage-scheme-do'

    it 'returns an array of cards currently in the stage', (done) ->
      @tester.request {orgid, stageid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {cards} = res.result
        expect(cards).to.exist
        expect(cards).to.have.length(1)
        expect(_.pluck(cards, 'id')).to.have.members ['card-takedbaby']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    stageid = 'stage-task-do'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, stageid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and stageid', ->

    orgid   = 'org-paddys'
    stageid = 'stage-task-do'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stageid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
