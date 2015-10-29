BlackListToken = require '../src/black-list-token'
crypto = require 'crypto'
redis  = require 'fakeredis'
uuid   = require 'uuid'

describe 'BlackListToken', ->
  beforeEach ->
    @redisKey = uuid.v1()
    @sut = new BlackListToken cache: redis.createClient(@redisKey), pepper: 'totally-a-secret'
    @cache = redis.createClient @redisKey

  describe '->do', ->
    context 'when given a uuid and token', ->
      beforeEach (done) ->
        request =
          metadata:
            responseId: 'its-electric'
            auth:
              uuid: 'electric-eels'
              token: 'these-current-events-are-shocking!'

        @sut.do request, (error, @response) => done error

      it 'should add a token to the cache', (done) ->
        @cache.exists "electric-eels:these-current-events-are-shocking!", (error, result) =>
          expect(result).to.deep.equal 1
          done()

      it 'should return a 204', ->
        expectedResponse =
          metadata:
            responseId: 'its-electric'
            code: 204
            status: 'No Content'

        expect(@response).to.deep.equal expectedResponse

    context 'when given a different uuid and token', ->
      beforeEach (done) ->
        request =
          metadata:
            responseId: 'brrrr'
            auth:
              uuid: 'trapped-in-blizzard'
              token: "There's snow going back now"

        @sut.do request, (error, @response) => done error

      it 'should add a hashed token to the cache', (done) ->
        @cache.exists "trapped-in-blizzard:There's snow going back now", (error, result) =>
          expect(result).to.deep.equal 1
          done()

      it 'should return a 204', ->
        expectedResponse =
          metadata:
            responseId: 'brrrr'
            code: 204
            status: 'No Content'

        expect(@response).to.deep.equal expectedResponse
