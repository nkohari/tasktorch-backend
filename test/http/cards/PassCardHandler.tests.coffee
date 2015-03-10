_               = require 'lodash'
expect          = require('chai').expect
TestData        = require 'test/framework/TestData'
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
PassCardHandler = require 'http/handlers/cards/PassCardHandler'
GetStackQuery   = require 'data/queries/stacks/GetStackQuery'

describe 'PassCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(PassCardHandler)
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
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'doesnotexist', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'org-paddys', cardid: 'doesnotexist', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a team or user argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with both a team and a user argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent user argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {user: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a user argument who is not a member of the org', ->
    it 'returns 400 bad request', (done) ->
      payload = {user: 'user-greg'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent team argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {team: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a team argument that does not belong to the org', ->
    it 'returns 400 bad request', (done) ->
      payload = {team: 'team-sudz'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid user argument', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    userid = 'user-dee'

    it "sets the card's user to the specified user and moves the card to the end of the user's inbox stack", (done) ->
      payload = {user: userid}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.user).to.equal(userid)
        expect(card.stack).to.equal('stack-dee-inbox')
        query = new GetStackQuery(card.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid team argument', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    teamid = 'team-dynamicduo'

    it "sets the card's team to the specified team and moves the card to the end of the team's inbox stack", (done) ->
      payload = {team: teamid}
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card.team).to.equal(teamid)
        expect(card.stack).to.equal('stack-dynamicduo-inbox')
        query = new GetStackQuery(card.stack)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.stack).to.exist()
          expect(result.stack.cards).to.be.an('array')
          expect(_.last(result.stack.cards)).to.equal(cardid)
          reset(done)

#---------------------------------------------------------------------------------------------------
