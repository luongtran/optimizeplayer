angular.module('optimizePlayer').factory 'Integration', ($resource, $http) ->
  class Integration
    constructor: () ->
      @service = $resource('/api/v1/integrations/:id',
        {id: '@id'}
        {update: {method: 'PUT'}}
        {get: {method: 'GET', isArray: false}})

    getProviders: () ->
      $http.get('/api/v1/integrations/providers')

    query: (params = {}) ->
      @service.query params
      .$promise

    get: (integration_id) ->
      @service.get {id: integration_id}
      .$promise

    create: (integration) ->
      payload = {
        title: integration.title,
        provider: integration.provider
      }
      if integration.api_credentials?
        for key, value of integration.api_credentials
          payload[key] = value

      new @service(integration: payload).$save()

    update: (integration) ->
      payload = {
        title: integration.title,
        provider: integration.provider
      }
      if integration.api_credentials?
        for key, value of integration.api_credentials
          payload[key] = value
      new @service(integration: payload).$update {id: integration.id}

    delete: (integration_id) ->
      @service.delete {id: integration_id}
      .$promise

    deleteFile: (params) ->
      if confirm "Are you sure?"
        $http.delete('/api/v1/integrations/remove_file', {
          params: params
        })

    loadMailChimpLists: (id) ->
      $http.get('/api/v1/integrations/mailchimp_lists', {
        params: {id: id}
      })

    loadAweberLists: (id) ->
      $http.get('/api/v1/integrations/aweber_lists', {
        params: {id: id}
      })

    loadGetresponseCampaigns: (id) ->
      $http.get('/api/v1/integrations/getresponse_campaigns', {
        params: {id: id}
      })

    loadCsnDirectories: (params) ->
      $http.get('/api/v1/integrations/csn_directories', {
        params: params
      })

    loadOPHostingBucket: ->
      $http.get('/api/v1/integrations/get_op_hosting_bucket', {
      })