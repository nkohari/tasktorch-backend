_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
MoveCardHandler = require 'apps/api/handlers/cards/MoveCardHandler'
GetStackQuery   = require 'data/queries/stacks/GetStackQuery'

describe 'cards:MoveCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(MoveCardHandler, 'user-charlie')
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestHarness.reset ['cards', 'notes', 'stacks'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, cardid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-charlie-inbox', position: 'append'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid   = 'org-paddys'
    cardid  = 'doesnotexist'
    payload = {stack: 'stack-charlie-inbox', position: 'append'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a stack argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {position: 'append'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent stack argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'doesnotexist', position: 'append'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a position argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-charlie-inbox'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid position argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-charlie-inbox', position: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe "when called for a user's stack not owned by the requester", ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-dee-inbox', position: 'append'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a stack owned by a team of which the requester is not a member', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-dynamicduo-inbox', position: 'append'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same stackid, and position=append', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-thegang-inbox', position: 'append'}

    it 'moves the card to the end of the specified stack', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card.stack).to.equal(payload.stack)
        query = new GetStackQuery(payload.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          expect(result.stack).to.exist
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same stackid, and position=prepend', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-thegang-inbox', position: 'prepend'}

    it 'moves the card to the beginning of the specified stack', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card.stack).to.equal(payload.stack)
        query = new GetStackQuery(payload.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          expect(result.stack).to.exist
          expect(result.stack.cards).to.be.an('array')
          expect(_.first(result.stack.cards)).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same stackid, and a numeric position', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-thegang-inbox', position: 0}

    it 'moves the card to the specified position in the specified stack', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card.stack).to.equal(payload.stack)
        query = new GetStackQuery(payload.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          expect(result.stack).to.exist
          expect(result.stack.cards).to.be.an('array')
          expect(result.stack.cards[payload.position]).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a different stackid, and position=append', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-charlie-inbox', position: 'append'}

    it 'moves the card to the end of the specified stack', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card.stack).to.equal(payload.stack)
        query = new GetStackQuery(payload.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          expect(result.stack).to.exist
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a different stackid, and position=prepend', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-charlie-inbox', position: 'prepend'}

    it 'moves the card to the beginning of the specified stack', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card.stack).to.equal(payload.stack)
        query = new GetStackQuery(payload.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          expect(result.stack).to.exist
          expect(result.stack.cards).to.be.an('array')
          expect(_.first(result.stack.cards)).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a different stackid, and a numeric position', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {stack: 'stack-charlie-inbox', position: 0}

    it 'moves the card to the specified position in the specified stack', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card.stack).to.equal(payload.stack)
        query = new GetStackQuery(payload.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          expect(result.stack).to.exist
          expect(result.stack.cards).to.be.an('array')
          expect(result.stack.cards[payload.position]).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------
