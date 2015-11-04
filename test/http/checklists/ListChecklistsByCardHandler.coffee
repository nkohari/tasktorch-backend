_                           = require 'lodash'
expect                      = require('chai').expect
TestHarness                 = require 'test/framework/TestHarness'
ListChecklistsByCardHandler = require 'apps/api/handlers/checklists/ListChecklistsByCardHandler'

describe 'checklists:ListChecklistsByCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListChecklistsByCardHandler, 'user-charlie')
      ready()

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

    orgid  = 'doesnotexist'
    cardid = 'card-takedbaby'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid  = 'org-paddys'
    cardid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid card in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'

    it 'returns an array of checklists in the card', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {checklists} = res.result
        expect(checklists).to.exist()
        expect(checklists).to.have.length(3)
        expect(_.pluck(checklists, 'id')).to.have.members ['checklist-takedbaby-plan', 'checklist-takedbaby-do', 'checklist-takedbaby-drink']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    cardid = 'card-ringbell'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->

    orgid  = 'org-paddys'
    cardid = 'card-ringbell'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
