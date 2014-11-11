angular.module("optimizePlayer").controller "ProjectEditCtrl",

["$scope", "$rootScope", "Project", "Asset", "CtaStore", "Integration", "$http", "$compile", "SkinsStore", '$timeout',
  ($scope, $rootScope, Project, Asset, CtaStore, Integration, $http, $compile, SkinsStore, $timeout) ->

    $scope.logo = new Asset(
      media_type: "$scope.logo"
      file_origin: "upload"
    )

    $scope.auto_start_options = [
      {"id":'no_autoplay',      "name":"No Autoplay"     },
      {"id":'autoplay_on_view', "name":"Autoplay On View"},
      {"id":'autoplay',         "name":"Autoplay"        }
    ];

    $scope.control_bar_hide_method_options = [
      {"id":'hide', "name": "Hide"      },
      {"id":'fade', "name": "Mouseover" },
      {"id":'drop', "name": "Minimal"   },
      {"id":'never',"name": "Do Nothing"}
    ];

    $scope.skins = SkinsStore.skins

    $scope.isModified = false

    $scope.project = new Project(
      allow_embed: "true"
      allow_pause: "true"
      allowed_urls: ""
      analytics: ""
      auto_start: "no_autoplay"
      dimensions: "720x405"
      display_time: "true"
      display_volume: "true"
      full_screen: "true"
      license_key: ""
      loop: "false"
      play_button: "true"
      scaling: "orig"
      facebook_share: "true"
      twitter_share: "true"
      google_share: "false"
      email_share: "false"
      skin: "skin0"
      tags: ""
      skin_color: "68,153,17"
      align: "none"
      big_play_button: "true"
      control_bar_hide_method: "fade"
      cb_gap: 4,
      title: "New Project"
      show_banner: "true"
      affiliate_link: ""
      logo: ""
    )

    $scope.assetProcessed = false

    $scope.encodingAsset  = false
    $scope.encodingAssetPercents = 0

    $scope.getCurrentProject = (opts) ->
      angular.extend $scope.project, new Project(opts)
      @integrationService = new Integration()
      @integrationService.get($scope.project.csn_id).then((response) ->
        $rootScope.csn = response
      )

    $scope.logo = {top: 0, left: 0, orig: ''}

    $scope.$watch 'project.dimensions', ->
      getDimensions();

    $scope.$watch 'project.custom_width', ->
      getDimensions();

    $scope.$watch 'project.custom_height', ->
      getDimensions();

    $scope.$watch 'project.max_width', ->
      getDimensions();

    $scope.$watch 'project.max_height', ->
      getDimensions();

    getDimensions = ->
      if $scope.project.dimensions == 'custom'
        $scope.widthPlayer = $scope.project.custom_width
        $scope.heightPlayer = $scope.project.custom_height
      else if $scope.project.dimensions == 'responsive'
        $scope.widthPlayer = $scope.project.max_width
        $scope.heightPlayer = $scope.project.max_height
      else
        $scope.widthPlayer = $scope.project.dimensions.split("x")[0]
        $scope.heightPlayer = $scope.project.dimensions.split("x")[1]

    #display share buttons for skin0
    $scope.showShareButtons = ->
      $scope.project.skin != 'skin0'

    $scope.init = (attrs) ->
      angular.extend $scope.project, new Project(attrs)
      $scope.setAutoStartOption($scope.project.auto_start)
      $scope.setControlBarHideMethodOption($scope.project.control_bar_hide_method)

      # Pull all ctas
      $scope.cta_store = CtaStore
      $scope.cta_store.get($scope.project.cid)

      $scope.logo.top = $scope.project.logo_pos_top
      $scope.logo.left = $scope.project.logo_pos_left

      if $scope.project.assets[0] and $scope.project.assets[0].unavailable
        $scope.encodingAsset = $scope.project.assets[0]
        $scope.showEncodingPopup()

    $scope.showEncodingPopup = ->
      $('#processing-video').modal('show');
      $scope.startEncoding()

    $scope.startEncoding = ->
      $scope.statusNotice = "Preparing"
      $http.get("/api/v1/assets/" + $scope.encodingAsset.id + "/start_encoding").success (data) ->
        unless data.video.errors.length > 0 
          if data.status == 'Encoding'
            pollEncodeInfo()
          else
            $scope.percentage = data.info.progress.percent + "%"
            $timeout ->
              $scope.startEncoding()
            , 1000

    pollEncodeInfo = ->
      $http.get("/api/v1/assets/" + $scope.encodingAsset.id + "/info_encoding").success (data) ->
        unless  data.info.errors.length > 0 
          if data.info.attributes.status == 'success'
            $scope.encodingAssetPercents = "100%"
            $scope.statusNotice = "Finishing"
            $scope.waitForAsset()
          else
            percentage = data.info.attributes.encoding_progress
            $scope.encodingAssetPercents = (if percentage == null then 0 else percentage) + "%"
            $timeout ->
              pollEncodeInfo()
            , 1000

    $scope.waitForAsset = ->
      $http.get("/api/v1/assets/" + $scope.encodingAsset.id + "/is_finished").success (data) ->
        if data.finished and JSON.parse(data.finished)
          $scope.encodingAsset.remote_url = data.remote_url
          $scope.closeEncodingPopup()
        else
          $timeout ->
            $scope.waitForAsset()
          , 1000

    $scope.closeEncodingPopup = ->
      $('#processing-video').modal('hide');
      $scope.project.url = $scope.encodingAsset.remote_url
      $scope.saveProject()
      window.location = "/projects/" + $scope.project.cid + "/edit"


    $scope.saveProject = (callback) ->
      $scope.project.tags = angular.element("input:hidden[name=\"hidden-tags\"]").val()
      $scope.project.allowed_urls = angular.element("input:hidden[name=\"hidden-urls\"]").val()
      $scope.isSaving = true
      $scope.isModified = false
      if ($scope.project.cid)
        $scope.project.$update () ->
          $scope.isSaving = false
      else
        $scope.project.$save (data) ->
          $scope.isSaving = false
          window.history.pushState null, null, "/projects/" + $scope.project.cid + "/edit"
          callback() unless callback is `undefined`

    $scope.setSkin = (skin) ->
      console.log "Skin ID: ", skin.id
      $scope.project.skin = skin.id
      $scope.project.skin_color = skin.color
      for item in $scope.skins
        item.selected = false
      skin.selected = true

    $scope.setModified = ->
      $scope.isModified = true

    $scope.setAutoStartOption = (val) ->
      if val == 'no_autoplay'
        $scope.auto_start_option = $scope.auto_start_options[0]
      if val == 'autoplay_on_view'
        $scope.auto_start_option = $scope.auto_start_options[1]
      if val == 'autoplay'
        $scope.auto_start_option = $scope.auto_start_options[2]
    $scope.setAutoStart = (val) ->
      $scope.project.auto_start = val.id

    $scope.setControlBarHideMethodOption = (val) ->
      if val == 'hide'
        $scope.control_bar_hide_method_option = $scope.control_bar_hide_method_options[0]
      if val == 'fade'
        $scope.control_bar_hide_method_option = $scope.control_bar_hide_method_options[1]
      if val == 'drop'
        $scope.control_bar_hide_method_option = $scope.control_bar_hide_method_options[2]
      if val == 'never'
        $scope.control_bar_hide_method_option = $scope.control_bar_hide_method_options[3]

    $scope.setControlBarHideMethod = (val) ->
      $scope.project.control_bar_hide_method = val.id

    $scope.embed_code = ->
      $scope.project.embedCode()

    $scope.setDimensions = (dimensions) ->
      $scope.project.dimensions = dimensions

    $scope.setStartImage = (link) ->
      $scope.project.start_image = link

    $scope.millisecondsToTime = (s) ->
      if s == false
        return 'pause'
      else
        ms = s % 1000;
        s = (s - ms) / 1000;
        secs = s % 60;
        s = (s - secs) / 60;
        mins = s % 60;
        return mins + ':' + secs;

    $scope.editTitle = ->
      project = $scope.project
      $timeout.cancel $scope.clickedOP
      $scope.clickedOP = null
      $scope.nameEditing = true
      $scope.newTitle  = project.title

    $scope.updateProjectTitle = ->
      project = $scope.project
      $scope.nameEditing = false
      if $scope.newTitle and $scope.newTitle != project.title
        project.title = $scope.newTitle
        Project.update(id: project.id, title: project.title)

]
