_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
MoveActionHandler = require 'apps/api/handlers/actions/MoveActionHandler'
GetChecklistQuery = require 'data/queries/checklists/GetChecklistQuery'

describe 'actions:MoveActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(MoveActionHandler, 'user-charlie')
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestHarness.reset ['actions', 'checklists', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, actionid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    actionid = 'action-takedbaby'
    orgid    = 'doesnotexist'
    payload  = {checklist: 'checklist-takedbaby-drink', position: 'append'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->

    actionid = 'doesnotexist'
    orgid    = 'org-paddys'
    payload  = {checklist: 'checklist-takedbaby-drink', position: 'append'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent checklist argument', ->

    actionid = 'action-takedbaby'
    orgid    = 'org-paddys'
    payload  = {checklist: 'doesnotexist', position: 'append'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a checklist argument', ->

    actionid = 'action-takedbaby'
    orgid    = 'org-paddys'
    payload  = {position: 'append'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a position argument', ->

    actionid = 'action-takedbaby'
    orgid    = 'org-paddys'
    payload  = {checklist: 'checklist-takedbaby-drink'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid position argument', ->

    actionid = 'action-takedbaby'
    orgid    = 'org-paddys'
    payload  = {checklist: 'checklist-takedbaby-drink', position: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist from the same card and position=append', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {checklist: 'checklist-takedbaby-drink', position: 'append'}
    cardid   = 'card-takedbaby'
    stageid  = 'stage-scheme-drink'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(payload.checklist)
        expect(action.stage).to.equal(stageid)
        done()

    it 'moves the action to the end of the checklist', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(payload.checklist)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.last(checklist.actions)).to.equal(actionid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist from the same card and position=prepend', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {checklist: 'checklist-takedbaby-drink', position: 'prepend'}
    cardid   = 'card-takedbaby'
    stageid  = 'stage-scheme-drink'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(payload.checklist)
        expect(action.stage).to.equal(stageid)
        done()

    it 'moves the action to the beginning of the specified checklist on the same card', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(payload.checklist)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.first(checklist.actions)).to.equal(actionid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist from the same card and a numeric position', ->

    orgid    = 'org-paddys'
    actionid = 'action-meetatlaterbar'
    payload  = {checklist: 'checklist-takedbaby-do', position: 1}
    cardid   = 'card-takedbaby'
    stageid  = 'stage-scheme-do'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(payload.checklist)
        expect(action.stage).to.equal(stageid)
        done()

    it 'moves the action to the specified position in the checklist', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(payload.checklist)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(checklist.actions[payload.position]).to.equal(actionid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with checklist from a different card and position=append', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {checklist: 'checklist-buygas-drink', position: 'append'}
    cardid   = 'card-buygas'
    stageid  = 'stage-scheme-drink'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(payload.checklist)
        expect(action.stage).to.equal(stageid)
        done()

    it 'moves the action to the end of the checklist', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(payload.checklist)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.last(checklist.actions)).to.equal(actionid)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist on a different card and position=prepend', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {checklist: 'checklist-buygas-drink', position: 'prepend'}
    cardid   = 'card-buygas'
    stageid  = 'stage-scheme-drink'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(payload.checklist)
        expect(action.stage).to.equal(stageid)
        done()

    it 'moves the action to the beginning of specified checklist', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(payload.checklist)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.first(checklist.actions)).to.equal(actionid)
          done()

#---------------------------------------------------------------------------------------------------
