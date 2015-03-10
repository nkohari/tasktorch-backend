_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
AcceptCardHandler = require 'http/handlers/cards/AcceptCardHandler'
GetStackQuery     = require 'data/queries/stacks/GetStackQuery'

describe 'AcceptCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(AcceptCardHandler)
      @database = TestHarness.getDatabase()
      ready()

  reset = (callback) ->
    TestData.reset ['cards', 'notes', 'stacks'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', cardid: 'card-takedbaby', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an unowned card in an org of which the requester is a member', ->
    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    it "moves the card to the bottom of the requester's queue and assigns it to the requester", (done) ->
      @tester.request {orgid, cardid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.user).to.equal('user-charlie')
        expect(card.stack).to.equal('stack-charlie-queue')
        query = new GetStackQuery(card.stack)
        @database.execute query, (err, result) =>
          expect(err).to.not.exist()
          expect(result.stack).to.exist()
          expect(_.last(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for a card currently owned by another user', ->
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'card-buygas', credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', cardid: 'card-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'card-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
