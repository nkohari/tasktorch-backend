_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
CommonBehaviors         = require 'test/framework/CommonBehaviors'
ListCardsByStackHandler = require 'http/handlers/cards/ListCardsByStackHandler'

describe 'ListCardsByStackHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListCardsByStackHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', stackid: 'stack-mac-queue'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', stackid: 'stack-mac-queue', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', stackid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid stack in an org of which the requester is a member', ->
    it 'returns an array of cards currently in the stack', (done) ->
      @tester.request {orgid: 'org-paddys', stackid: 'stack-mac-queue', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {cards} = res.body
        expect(cards).to.exist()
        expect(cards).to.have.length(1)
        expect(_.pluck(cards, 'id')).to.have.members ['card-buygas']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', stackid: 'stack-sudz-inbox', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and stackid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', stackid: 'stack-sudz-inbox', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
