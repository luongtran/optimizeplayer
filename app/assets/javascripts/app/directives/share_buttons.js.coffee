"use strict"
angular.module("optimizePlayer").directive "shareButtons", ->
  restrict: 'A'
  link: ($scope, $element, $attrs) ->
    window.onload = ->
      s = document.createElement 'script'
      s.type = 'text/javascript'
      s.src = '//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52e8cdc84d9ac2b4&async=1'
      document.body.appendChild(s)

      addthis.user.ready (data) ->
        # addthis_config = addthis_config||{};
        # addthis_config.data_track_addressbar = false;
        # addthis_config.data_track_clickback = false;
        addthis.init()

    #init project from attributes if was not initialized
    unless $scope.project
      $scope.project = JSON.parse($attrs.project)



