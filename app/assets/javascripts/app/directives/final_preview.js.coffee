"use strict"
angular.module("optimizePlayer").directive "finalPreview", ["SkinsStore", '$timeout', 'CtaStore', (SkinsStore, $timeout, CtaStore) ->
  link: ($scope, $element, $attrs) ->

    $scope.$watch 'project', ->
      if optimizeplayer.player and optimizeplayer.player.isLoaded()
        $scope.setModified()
    , true

    $scope.$watch 'project.full_screen', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").displayFullscreen $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.play_button', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").displaySmallPlay $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.big_play_button', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").displayBigPlay $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.display_time', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").displayTime $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.mute', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").allowMute $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.display_volume', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").displayVolume $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.allow_pause', (val) ->
      optimizeplayer.player.getPlugin("skin_controls").allowPause $scope.isTrue(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()

    $scope.$watch 'project.skin_color', (val) ->
      if optimizeplayer.player and optimizeplayer.player.isLoaded()
        optimizeplayer.player.getPlugin("skin_controls").setColor parseInt(optimizeplayer.colorConverter.RGBToBin(val.split(',')))

    $scope.$watch 'project.control_bar_hide_method', (val) ->
      if optimizeplayer.player and optimizeplayer.player.isLoaded()
        if val == 'hide'
          optimizeplayer.player.getPlugin("skin_controls").displayControls false
        else
          optimizeplayer.player.getPlugin("skin_controls").displayControls true
          optimizeplayer.player.getPlugin("skin_controls").setHideMethod val
          
    $scope.$watch 'control_bar_hide_method_option', (val) ->
      $scope.setControlBarHideMethod(val)

    $scope.$watch 'project.cb_gap', (val) ->
      if optimizeplayer.player and optimizeplayer.player.isLoaded()
        $scope.setModified()
      optimizeplayer.player.getPlugin("skin_controls").setGap parseInt(val) if optimizeplayer.player and optimizeplayer.player.isLoaded()
      
    $scope.$watch 'project.affiliate_link', (val) ->
      if optimizeplayer.player and optimizeplayer.player.isLoaded()
        optimizeplayer.player.getPlugin("skin_controls").setBrandingURL( _getBrandingURL() )
        
    $scope.$watch 'project.show_banner', (val) ->
      if optimizeplayer.player and optimizeplayer.player.isLoaded()
        if $scope.isTrue(val)
          optimizeplayer.player.getPlugin("skin_controls").setBrandingURL(_getBrandingURL())
        else
          optimizeplayer.player.getPlugin("skin_controls").setBrandingURL("")

    $scope.$watch 'project.start_image', (val) ->
      $scope.project.auto_start = "no_autoplay" if val
      
    $scope.$watch 'project.auto_start', (val) ->
      $scope.initPlayer()

    $scope.$watch 'auto_start_option', (val) ->
      $scope.setAutoStart(val)

    $scope.$watch "[project.scaling, project.logo, project.logo_position, project.allow_embed, 
                    project.auto_mute, project.facebook_share, project.twitter_share, project.autoplay, project.loop, project.start_image, project.skin]", (->
      $scope.initPlayer()
    ), true

    #default affiliate link
    _getBrandingURL = ->
      default_affilate_link = "http://www.optimizeplayer.com/?ims=bnr"
      unless $scope.project.affiliate_link == ""
        default_affilate_link = $scope.project.affiliate_link

      default_affilate_link

    $scope.isTrue = (val) ->
      val isnt "false" and val isnt false and val isnt `undefined`

    $scope.initPlayer = ->
      optimizeplayer.project = $scope.project
      
      $scope.cta_store.promise.then (data) ->
        $timeout ->
          optimizeplayer.cta_store = $scope.cta_store
          optimizeplayer.embed = false
          $(".cta").hide()
          optimizeplayer.initplayer()
        , 0
]