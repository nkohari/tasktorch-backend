_               = require 'lodash'
expect          = require('chai').expect
TestData        = require 'test/framework/TestData'
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
MoveCardHandler = require 'apps/api/handlers/cards/MoveCardHandler'
GetStackQuery   = require 'data/queries/stacks/GetStackQuery'

describe 'MoveCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(MoveCardHandler)
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
      payload = {stack: 'stack-inbox-charlie', position: 'append'}
      @tester.request {orgid: 'doesnotexist', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      payload = {stack: 'stack-inbox-charlie', position: 'append'}
      @tester.request {orgid: 'org-paddys', cardid: 'doesnotexist', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a stack argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {position: 'append'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent stack argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {stack: 'doesnotexist', position: 'append'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a position argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {stack: 'stack-inbox-charlie'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid position argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {stack: 'stack-inbox-charlie', position: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe "when called for a user's stack not owned by the requester", ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-dee-inbox'
    position = 'append'

    it 'returns 403 forbidden', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a stack owned by a team of which the requester is not a member', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-dynamicduo-inbox'
    position = 'append'

    it 'returns 403 forbidden', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same stackid, and position=append', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-thegang-inbox'
    position = 'append'

    it 'moves the card to the end of the specified stack', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.stack).to.equal(stackid)
        query = new GetStackQuery(stackid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same stackid, and position=prepend', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-thegang-inbox'
    position = 'prepend'

    it 'moves the card to the beginning of the specified stack', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.stack).to.equal(stackid)
        query = new GetStackQuery(stackid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.first(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same stackid, and a numeric position', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-thegang-inbox'
    position = 0

    it 'moves the card to the specified position in the specified stack', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.stack).to.equal(stackid)
        query = new GetStackQuery(stackid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(result.stack.cards[position]).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a different stackid, and position=append', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-charlie-inbox'
    position = 'append'

    it 'moves the card to the end of the specified stack', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.stack).to.equal(stackid)
        query = new GetStackQuery(stackid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a different stackid, and position=prepend', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-charlie-inbox'
    position = 'prepend'

    it 'moves the card to the beginning of the specified stack', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.stack).to.equal(stackid)
        query = new GetStackQuery(stackid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.first(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a different stackid, and a numeric position', ->

    orgid    = 'org-paddys'
    cardid   = 'card-takedbaby'
    stackid  = 'stack-charlie-inbox'
    position = 0

    it 'moves the card to the specified position in the specified stack', (done) ->
      payload = {stack: stackid, position}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.stack).to.equal(stackid)
        query = new GetStackQuery(stackid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(result.stack.cards[position]).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------
