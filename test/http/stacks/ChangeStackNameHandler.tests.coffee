_                      = require 'lodash'
expect                 = require('chai').expect
TestHarness            = require 'test/framework/TestHarness'
ChangeStackNameHandler = require 'apps/api/handlers/stacks/ChangeStackNameHandler'

describe 'stacks:ChangeStackNameHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeStackNameHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['stacks'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid   = 'org-paddys'
    stackid = 'stack-charlie-dreams'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, stackid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid   = 'doesnotexist'
    stackid = 'stack-charlie-dreams'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent stack', ->

    orgid   = 'org-paddys'
    stackid = 'doesnotexist'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->

    orgid   = 'org-paddys'
    stackid = 'stack-charlie-dreams'
    payload = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null name argument', ->

    orgid   = 'org-paddys'
    stackid = 'stack-charlie-dreams'
    payload = {name: null}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-backlog stack owned by the requester', ->

    orgid   = 'org-paddys'
    stackid = 'stack-charlie-inbox'
    payload = {name: new Date().valueOf().toString()}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a backlog stack owned by the requester', ->

    orgid   = 'org-paddys'
    stackid = 'stack-charlie-dreams'
    payload = {name: new Date().valueOf().toString()}

    it 'changes the name of the stack', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {stack} = res.result
        expect(stack).to.exist
        expect(stack.id).to.equal(stackid)
        expect(stack.name).to.equal(payload.name)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid   = 'org-sudz'
    stackid = 'stack-sudz-inbox'
    payload = {name: 'Test'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and stackid', ->

    orgid   = 'org-paddys'
    stackid = 'stack-sudz-inbox'
    payload = {name: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
