module.exports =

  '/sessions':
    post:
      handler: 'SessionController.create'
      auth:    {mode: 'try'}

  '/sessions/{sessionId}':
    delete: 'SessionController.end'

  '/organizations/{organizationId}/cards':
    get:    'CardController.search'
    post:   'CardController.create'

  '/organizations/{organizationId}/cards/{cardId}':
    get:    'CardController.get'
    pass:   'CardController.pass'
    delete: 'CardController.delete'

  '/users/{userId}':
    changePassword: {handler: 'UserController.changePassword', auth: false}
