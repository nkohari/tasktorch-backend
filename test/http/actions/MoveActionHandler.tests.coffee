_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
MoveActionHandler = require 'http/handlers/actions/MoveActionHandler'
GetChecklistQuery = require 'data/queries/checklists/GetChecklistQuery'

describe 'MoveActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(MoveActionHandler)
      @database = TestHarness.getDatabase()
      ready()

  reset = (callback) ->
    TestData.reset ['actions', 'checklists', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', actionid: 'action-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    actionid    = 'action-takedbaby'
    checklistid = 'checklist-takedbaby-drink'
    orgid       = 'doesnotexist'
    position    = 'append'

    it 'returns 404 not found', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->

    actionid    = 'doesnotexist'
    checklistid = 'checklist-takedbaby-drink'
    orgid       = 'org-paddys'
    position    = 'append'

    it 'returns 404 not found', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent checklist argument', ->

    actionid    = 'action-takedbaby'
    checklistid = 'doesnotexist'
    orgid       = 'org-paddys'
    position    = 'append'

    it 'returns 400 bad request', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a checklist argument', ->

    actionid    = 'action-takedbaby'
    orgid       = 'org-paddys'
    position    = 'append'

    it 'returns 400 bad request', (done) ->
      payload = {position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a position argument', ->

    actionid    = 'action-takedbaby'
    checklistid = 'checklist-takedbaby-drink'
    orgid       = 'org-paddys'

    it 'returns 400 bad request', (done) ->
      payload = {checklist: checklistid}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid position argument', ->

    actionid    = 'action-takedbaby'
    checklistid = 'checklist-takedbaby-drink'
    orgid       = 'org-paddys'
    position    = 'doesnotexist'

    it 'returns 400 bad request', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist from the same card and position=append', ->

    orgid       = 'org-paddys'
    actionid    = 'action-takedbaby'
    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-drink'
    stageid     = 'stage-scheme-drink'
    position    = 'append'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        reset(done)

    it 'moves the action to the end of the checklist', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(checklistid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.last(checklist.actions)).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist from the same card and position=prepend', ->

    orgid       = 'org-paddys'
    actionid    = 'action-takedbaby'
    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-drink'
    stageid     = 'stage-scheme-drink'
    position    = 'prepend'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        reset(done)

    it 'moves the action to the beginning of the specified checklist on the same card', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(checklistid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.first(checklist.actions)).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist from the same card and a numeric position', ->

    orgid       = 'org-paddys'
    actionid    = 'action-meetatlaterbar'
    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-do'
    stageid     = 'stage-scheme-do'
    position    = 1

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        reset(done)

    it 'moves the action to the specified position in the checklist', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(checklistid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(checklist.actions[position]).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with checklist from a different card and position=append', ->

    orgid       = 'org-paddys'
    actionid    = 'action-takedbaby'
    cardid      = 'card-buygas'
    checklistid = 'checklist-buygas-drink'
    stageid     = 'stage-scheme-drink'
    position    = 'append'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        reset(done)

    it 'moves the action to the end of the checklist', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(checklistid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.last(checklist.actions)).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a checklist on a different card and position=prepend', ->

    orgid       = 'org-paddys'
    actionid    = 'action-takedbaby'
    cardid      = 'card-buygas'
    checklistid = 'checklist-buygas-drink'
    stageid     = 'stage-scheme-drink'
    position    = 'prepend'

    it 'sets the card, checklist, and stage correctly on the action', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal(actionid)
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        reset(done)

    it 'moves the action to the beginning of specified checklist', (done) ->
      payload = {checklist: checklistid, position}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetChecklistQuery(checklistid)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {checklist} = result
          expect(checklist).to.exist()
          expect(checklist.actions).to.be.an('array')
          expect(_.first(checklist.actions)).to.equal(actionid)
          reset(done)

#---------------------------------------------------------------------------------------------------
