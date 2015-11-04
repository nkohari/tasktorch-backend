_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
PassCardHandler = require 'apps/api/handlers/cards/PassCardHandler'
GetStackQuery   = require 'data/queries/stacks/GetStackQuery'

describe 'cards:PassCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(PassCardHandler, 'user-charlie')
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
    payload = {user: 'user-dee'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid   = 'org-paddys'
    cardid  = 'doesnotexist'
    payload = {user: 'user-dee'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a team or user argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with both a team and a user argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {user: 'user-dee', team: 'team-dynamicduo'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent user argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {user: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is not a member of the org', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {user: 'user-greg'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent team argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {team: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a team argument that does not belong to the org', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {team: 'team-sudz'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid user argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {user: 'user-dee'}

    it "sets the card's user to the specified user and moves the card to the end of the user's inbox stack", (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.user).to.equal(payload.user)
        expect(card.stack).to.equal('stack-dee-inbox')
        query = new GetStackQuery(card.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid team argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {team: 'team-dynamicduo'}

    it "sets the card's team to the specified team and moves the card to the end of the team's inbox stack", (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.team).to.equal(payload.team)
        expect(card.stack).to.equal('stack-dynamicduo-inbox')
        query = new GetStackQuery(card.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          done()

#---------------------------------------------------------------------------------------------------
