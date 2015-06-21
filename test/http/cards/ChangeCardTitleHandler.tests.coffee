_                      = require 'lodash'
expect                 = require('chai').expect
TestData               = require 'test/framework/TestData'
TestHarness            = require 'test/framework/TestHarness'
CommonBehaviors        = require 'test/framework/CommonBehaviors'
ChangeCardTitleHandler = require 'apps/api/handlers/cards/ChangeCardTitleHandler'

describe 'ChangeCardTitleHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeCardTitleHandler)
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
    payload = {title: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    orgid   = 'org-paddys'
    cardid  = 'doesnotexist'
    payload = {title: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a title argument', ->
    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null title argument', ->
    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {title: null}
    it 'changes the title of the card to null', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.title).to.equal(payload.title)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for a card in an org of which the requester is a member', ->
    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {title: new Date().valueOf().toString()}
    it 'changes the title of the card', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.title).to.equal(payload.title)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    cardid  = 'card-ringbell'
    payload = {title: 'Test'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    orgid   = 'org-paddys'
    cardid  = 'card-ringbell'
    payload = {title: 'Test'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
