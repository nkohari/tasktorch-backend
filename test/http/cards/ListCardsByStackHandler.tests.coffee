_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
ListCardsByStackHandler = require 'apps/api/handlers/cards/ListCardsByStackHandler'

describe 'cards:ListCardsByStackHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListCardsByStackHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid   = 'org-paddys'
    stackid = 'stack-mac-queue'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, stackid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    stackid = 'stack-mac-queue'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent stack', ->

    orgid   = 'org-paddys'
    stackid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid stack in an org of which the requester is a member', ->

    orgid   = 'org-paddys'
    stackid = 'stack-mac-queue'

    it 'returns an array of cards currently in the stack', (done) ->
      @tester.request {orgid, stackid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {cards} = res.result
        expect(cards).to.exist
        expect(cards).to.have.length(1)
        expect(_.pluck(cards, 'id')).to.have.members ['card-buygas']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    stackid = 'stack-sudz-inbox'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, stackid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and stackid', ->

    orgid   = 'org-paddys'
    stackid = 'stack-sudz-inbox'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
