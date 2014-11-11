angular.module("optimizePlayer").controller "ProjectNewCtrl", ["$scope", "$rootScope", "Project", "Integration", "$http", 'Asset', '$filter',
  ($scope, $rootScope, Project, Integration, $http, Asset, $filter) ->

    $rootScope.loadInfo = false

    $rootScope.opts = csnForUpload: null

    @integrationForChecking = new Integration()
    @integrationForChecking.query({provider: 'amazons3', integration_type: 'csn'}).then((response) ->
      $rootScope.showS3Auth = if response.length > 0 then false else true
    )

    @integrationForChecking.query({provider: 'rackspace'}).then((response) ->
      $rootScope.showRackspaceAuth = if response.length > 0 then false else true
    )

    $scope.$watch "loadInfo", ->
      if $rootScope.loadInfo == true
        $scope.loadIntegrationInfo()

    $scope.loadIntegrationInfo = ->
      @integrationService = new Integration()

      switch $scope.tab
        when 'hosting'
          $scope.type = 'company_csn'
          $scope.sourceType = 'amazons3'
          unless $scope.current_hosting_csn
            @integrationService.query({integration_type: $scope.type}).then((response) ->
              $rootScope.csns = response
              hosting_csns = $filter('filter')($rootScope.csns, {provider: $scope.sourceType})
              if hosting_csns? && hosting_csns.length > 0
                $rootScope.current_hosting_csn = $rootScope.opts.csnForUpload = hosting_csns[0]
              else
                $rootScope.current_hosting_csn = null
            )

        when 'amazon'
          $scope.type = 'csn'
          $scope.sourceType = 'amazons3'
          $scope.setCurrentCsn()

        when 'rackspace'
          $scope.type = 'csn'
          $scope.sourceType = 'rackspace'
          $scope.setCurrentCsn()

    $scope.setCurrentCsn = ->
      @integrationService.query({integration_type: $scope.type}).then((response) ->
        $rootScope.csns = response
        csns = $filter('filter')($rootScope.csns, {provider: $scope.sourceType})
        if csns? && csns.length > 0
          $rootScope.current_csn = $rootScope.opts.csnForUpload = csns[0]
          $rootScope.csn = csns[0]
        else
          $rootScope.current_csn = null
      )

    $scope.$watch "tab", ->
      $rootScope.goToNextStep = false
      $rootScope.invalidCredentialsMessage = ''
      if $rootScope.loadInfo == true
        $scope.loadIntegrationInfo()

    $scope.project = new Project(
      affiliate_link: ""
      align: "none"
      allow_embed: true
      allow_pause: true
      allowed_urls: ""
      analytics: ""
      asset_ids: []
      auto_start: "no_autoplay"
      big_play_button: true
      cb_gap: 4,
      control_bar_hide_method: "fade"
      dimensions: "720x405"
      display_time: true
      display_volume: true
      email_share: false
      facebook_share: true
      full_screen: true
      google_share: false
      license_key: ""
      loop: false
      play_button: true
      scaling: "orig"
      show_banner: true
      skin: "skin0"
      skin_color: "68,153,17"
      tags: ""
      title: "New Project"
      twitter_share: true

    )

    $scope.asset = new Asset(
      media_type: "video"
      file_origin: "upload"
      original_filename: false
      needs_encoding: "false"
    )

    $scope.assetProcessed = false

    $scope.tab = "hosting"

    $scope.updateProject = ->
        $scope.project.asset_ids.push($scope.asset.id)
        $scope.project.csn_id = $scope.asset.csn_id
        $scope.project.url = $scope.asset.remote_url

    $scope.createProject = (callback) ->
      unless $scope.isSaving
        $scope.saveProject ->
          window.location = "/projects/" + $scope.project.cid + "/edit"

    $scope.saveProject = (callback) ->
      $scope.isSaving = true
      $scope.project.$save (data) ->
        $scope.isSaving = false
        window.history.pushState null, null, "/projects/" + $scope.project.cid + "/edit"
        callback() unless callback is `undefined`

]
