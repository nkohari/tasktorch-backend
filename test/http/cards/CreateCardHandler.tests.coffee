_                 = require 'lodash'
expect            = require('chai').expect
TestHarness       = require 'test/framework/TestHarness'
CreateCardHandler = require 'apps/api/handlers/cards/CreateCardHandler'
GetStackQuery     = require 'data/queries/stacks/GetStackQuery'

describe 'cards:CreateCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateCardHandler, 'user-charlie')
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestHarness.reset ['cards', 'checklists', 'notes', 'stacks'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid   = 'org-oldiesrockcafe'
    payload = {kind: 'kind-scheme'}

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, payload}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    payload = {kind: 'kind-scheme'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a kind argument', ->

    orgid   = 'org-paddys'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a kind argument that does not belong to the org', ->

    orgid   = 'org-paddys'
    payload = {kind: 'kind-task'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid   = 'org-paddys'
    payload = {kind: 'kind-scheme'}

    it "creates the card and adds it to end of the requester's drafts stack", (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card).to.exist
        expect(card.org).to.equal(orgid)
        expect(card.user).to.equal('user-charlie')
        expect(card.stack).to.equal('stack-charlie-drafts')
        query = new GetStackQuery(card.stack)
        @database.execute query, (err, result) =>
          expect(err).to.not.exist
          expect(result.stack).to.exist
          expect(_.last(result.stack.cards)).to.equal(card.id)
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a title argument', ->

    orgid = 'org-paddys'
    payload = {kind: 'kind-scheme', title: new Date().valueOf().toString()}

    it 'creates the card and sets its title to the specified value', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card).to.exist
        expect(card.title).to.equal(payload.title)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a summary argument', ->

    orgid = 'org-paddys'
    payload = {kind: 'kind-scheme', summary: new Date().valueOf().toString()}

    it 'creates the card and sets its summary to the specified value', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card).to.exist
        expect(card.summary).to.equal(payload.summary)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    payload = {kind: 'kind-task'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
