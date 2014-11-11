angular.module('optimizePlayer').controller 'IntegrationCtrl', ($scope, $rootScope, $filter, Integration) ->

  $scope.providers = []

  $scope.integration = {
    api_credentials: []
  }

  $scope.init = (providers, integration_id) ->
    @integrationService = new Integration()

    $scope.providers = providers
    @integrationService.query().then((data) ->
      $rootScope.integrations = data
      )

  $scope.editIntegration = (integration_id) ->
    @integrationService.get(integration_id).then((response) ->
        $scope.integration = response
      )
    $scope.integration.editing = true

  $scope.saveIntegration = ->
    if $scope.integration.id?
      @integrationService.update($scope.integration).then((response) ->
        $rootScope.invalidCredentialsMessage = ''
        $scope.integration.provider = null
        $scope.integration.api_credentials = []
        $scope.integration.title = ''
        $scope.integration.editing = false
        @integrationService.query().then((data) ->
          $rootScope.integrations = data
          )
      )
    else
      $scope.integration.provider = $scope.sourceType if $scope.sourceType == ('amazons3' || 'rackspace')
      $scope.integration.integration_type = $scope.type if $scope.type
      @integrationService.create($scope.integration).then ((response) ->
        if response.provider == 'amazons3'
          $rootScope.showS3Auth = false
        if response.provider == 'rackspace'
          $rootScope.showRackspaceAuth = false
        $rootScope.invalidCredentialsMessage = ''
        $scope.integration.provider = null
        $scope.integration.api_credentials = []
        $scope.integration.title = ''
        @integrationService.query().then((data) ->
          $rootScope.integrations = data
          )
      ), ((error) ->
       $rootScope.invalidCredentialsMessage = error.data
      )

      if $scope.type = "csn"
        @integrationService = new Integration()
        @integrationService.query({integration_type: $scope.type}).then((response) ->
          $rootScope.csns = response
          csns = $filter('filter')($rootScope.csns, {provider: $scope.sourceType})
          if csns? && csns.length > 0
            $rootScope.current_csn = $rootScope.opts.csnForUpload = csns[0]
          else
            $rootScope.current_csn = null
        )

  $scope.deleteIntegration = (integration_id) ->
    if confirm('Do you really want to delete the integration?')
      @integrationService.delete(integration_id).then((response) ->
        $scope.integration.provider = null
        $scope.integration.api_credentials = []
        $scope.integration.title = ''
        @integrationService.query().then((data) ->
          $rootScope.integrations = data
          )
      )
      checkForIntegrations()

  $scope.getProviderImage = (provider) ->
    if provider.provider
      url = 'logo-' + provider.provider + '.png'
    else
      url = 'logo.png'
    url

  checkForIntegrations = ->
    @integration = new Integration()
    @integration.query({provider: 'amazons3', integration_type: 'csn'}).then((response) ->
      $rootScope.showS3Auth = if response.length > 0 then false else true
    )

    @integration.query({provider: 'rackspace'}).then((response) ->
      $rootScope.showRackspaceAuth = if response.length > 0 then false else true
    )

  $scope.onProgressChange = (value) ->
    $scope.percentage = value + '%'

