expect            = require('chai').expect
TestHarness       = require 'test/framework/TestHarness'
CreateNoteHandler = require 'apps/api/handlers/notes/CreateNoteHandler'

describe 'notes:CreateNoteHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateNoteHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['cards', 'notes'], done

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
    payload = {type: 'Comment', content: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid   = 'org-paddys'
    cardid  = 'doesnotexist'
    payload = {type: 'Comment', content: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a type argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {content: 'Test'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid type argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {type: 'doesnotexist', content: 'Test'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a content argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {type: 'Comment'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with type Comment and a valid content argument', ->

    orgid   = 'org-paddys'
    cardid  = 'card-takedbaby'
    payload = {type: 'Comment', content: new Date().valueOf().toString()}

    it 'creates a comment note on the specified card with the specified content', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {note} = res.result
        expect(note.card).to.equal(cardid)
        expect(note.type).to.equal(payload.type)
        expect(note.content).to.equal(payload.content)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    cardid  = 'card-ringbell'
    payload = {type: 'Comment', content: 'Test'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->

    orgid   = 'org-paddys'
    cardid  = 'card-ringbell'
    payload = {type: 'Comment', content: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------
