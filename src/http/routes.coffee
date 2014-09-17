module.exports =

  '/organizations/{organizationId}/cards':
    get:    'CardResource.search'
    post:   'CardResource.create'

  '/organizations/{organizationId}/cards/{cardId}':
    get:    'CardResource.get'
    pass:   'CardResource.pass'
    delete: 'CardResource.delete'
