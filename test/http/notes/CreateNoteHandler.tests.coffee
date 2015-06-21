expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
CreateNoteHandler = require 'apps/api/handlers/notes/CreateNoteHandler'

describe 'CreateNoteHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateNoteHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      payload = {type: 'Comment', content: 'Test'}
      @tester.request {orgid: 'doesnotexist', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      payload = {type: 'Comment', content: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'doesnotexist', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a type argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {content: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid type argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {type: 'doesnotexist', content: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a content argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {type: 'Comment'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with type Comment and a valid content argument', ->
    type    = 'Comment'
    content = new Date().valueOf().toString()
    it 'creates a comment note on the specified card with the specified content', (done) ->
      payload = {type, content}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {note} = res.result
        expect(note.card).to.equal('card-takedbaby')
        expect(note.type).to.equal(type)
        expect(note.content).to.equal(content)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      payload = {type: 'Comment', content: 'Test'}
      @tester.request {orgid: 'org-sudz', cardid: 'card-ringbell', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    it 'returns 404 not found', (done) ->
      payload = {type: 'Comment', content: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-ringbell', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------
