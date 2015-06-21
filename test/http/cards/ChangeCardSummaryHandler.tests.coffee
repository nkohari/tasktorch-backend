_                        = require 'lodash'
expect                   = require('chai').expect
TestData                 = require 'test/framework/TestData'
TestHarness              = require 'test/framework/TestHarness'
CommonBehaviors          = require 'test/framework/CommonBehaviors'
ChangeCardSummaryHandler = require 'apps/api/handlers/cards/ChangeCardSummaryHandler'

describe 'ChangeCardSummaryHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeCardSummaryHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid   = 'doesnotexist'
    cardid  = 'card-takedbaby'
    payload = {summary: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    orgid   = 'org-paddys'
    cardid  = 'doesnotexist'
    payload = {summary: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a summary argument', ->
    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null summary argument', ->
    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {summary: null}
    it 'changes the summary of the card to null', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.summary).to.equal(payload.summary)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for a card in an org of which the requester is a member', ->
    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {summary: new Date().valueOf().toString()}
    it 'changes the summary of the card', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.summary).to.equal(payload.summary)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    cardid  = 'card-ringbell'
    payload = {summary: 'Test'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    orgid   = 'org-paddys'
    cardid  = 'card-ringbell'
    payload = {summary: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
