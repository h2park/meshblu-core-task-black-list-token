class BlackListToken
  constructor: (options={}) ->
    {@cache} = options

  do: (request, callback) =>
    {uuid,token} = request.metadata.auth

    @cache.set "#{uuid}:#{token}", '', (error) =>
      return callback error if error?
      callback null,
        metadata:
          responseId: request.metadata.responseId
          code: 204
          status: 'No Content'

module.exports = BlackListToken
