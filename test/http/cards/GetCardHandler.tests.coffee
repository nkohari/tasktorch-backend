_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetCardHandler  = require 'http/handlers/cards/GetCardHandler'

describe 'GetCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetCardHandler)
      ready()

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

  describe 'when called for a valid card in an org of which the requester is a member', ->
    it 'returns the card', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {card} = res.body
        expect(card).to.exist()
        expect(card.id).to.equal('card-takedbaby')
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
