_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
MoveActionHandler = require 'http/handlers/actions/MoveActionHandler'
GetCardQuery      = require 'data/queries/cards/GetCardQuery'

describe 'MoveActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(MoveActionHandler)
      @database = TestHarness.getDatabase()
      ready()

  reset = (callback) ->
    TestData.reset ['actions', 'cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', actionid: 'action-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      payload = {card: 'card-takedbaby', stage: 'stage-scheme-drink', position: 'append'}
      @tester.request {orgid: 'doesnotexist', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      payload = {card: 'card-takedbaby', stage: 'stage-scheme-drink', position: 'append'}
      @tester.request {orgid: 'org-paddys', actionid: 'doesnotexist', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a card argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {stage: 'stage-scheme-drink', position: 'append'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent card argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {card: 'doesnotexist', stage: 'stage-scheme-drink', position: 'append'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent stage argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {card: 'card-takedbaby', stage: 'doesnotexist', position: 'append'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a stage argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {card: 'card-takedbaby', position: 'append'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent stage argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {card: 'card-takedbaby', stage: 'doesnotexist', position: 'append'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a position argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {card: 'card-takedbaby', stage: 'stage-scheme-drink'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid position argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {card: 'card-takedbaby', stage: 'stage-scheme-drink', position: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same cardid, a new stageid, and position=append', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    cardid   = 'card-takedbaby'
    stageid  = 'stage-scheme-drink'
    position = 'append'

    it 'moves the action to the end specified stage on the same card', (done) ->
      payload = {card: cardid, stage: stageid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.stage).to.equal(stageid)
        query = new GetCardQuery(cardid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.card).to.exist()
          actions = result.card.actions[stageid]
          expect(actions).to.be.an('array')
          expect(_.last(result.card.actions[stageid])).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same cardid, a new stageid, and position=prepend', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    cardid   = 'card-takedbaby'
    stageid  = 'stage-scheme-drink'
    position = 'prepend'

    it 'moves the action to the beginning of the specified stage on the same card', (done) ->
      payload = {card: cardid, stage: stageid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.stage).to.equal(stageid)
        query = new GetCardQuery(cardid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.card).to.exist()
          actions = result.card.actions[stageid]
          expect(actions).to.be.an('array')
          expect(_.first(result.card.actions[stageid])).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with the same cardid, a new stageid, and a numeric position', ->

    orgid    = 'org-paddys'
    actionid = 'action-meetatlaterbar'
    cardid   = 'card-takedbaby'
    stageid  = 'stage-scheme-do'
    position = 1

    it 'moves the action to the specified position in the specified stage on the same card', (done) ->
      payload = {card: cardid, stage: stageid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.stage).to.equal(stageid)
        query = new GetCardQuery(cardid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.card).to.exist()
          actions = result.card.actions[stageid]
          expect(actions).to.be.an('array')
          expect(result.card.actions[stageid][position]).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a new cardid, a new stageid, and position=append', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    cardid   = 'card-buygas'
    stageid  = 'stage-scheme-drink'
    position = 'append'

    it 'moves the action to the beginning of the specified stage on the new card', (done) ->
      payload = {card: cardid, stage: stageid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.stage).to.equal(stageid)
        query = new GetCardQuery(cardid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.card).to.exist()
          actions = result.card.actions[stageid]
          expect(actions).to.be.an('array')
          expect(_.last(result.card.actions[stageid])).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a new cardid, a new stageid, and position=prepend', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    cardid   = 'card-buygas'
    stageid  = 'stage-scheme-drink'
    position = 'prepend'

    it 'moves the action to the beginning of the specified stage on the new card', (done) ->
      payload = {card: cardid, stage: stageid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.stage).to.equal(stageid)
        query = new GetCardQuery(cardid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          expect(result.card).to.exist()
          actions = result.card.actions[stageid]
          expect(actions).to.be.an('array')
          expect(_.first(result.card.actions[stageid])).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------
