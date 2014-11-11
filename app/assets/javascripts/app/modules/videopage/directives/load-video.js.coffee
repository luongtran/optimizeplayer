'use strict'

angular.module("videopage").directive 'loadVideo', ['$http', ($http)->
  restrict: "A"
  controller: 'VideoPageCtrl'
  link: (scope, elem, attrs, controller) ->
    $http(
      method: 'GET',
      url: "/projects/#{scope.project.cid}.js?load_to_element=video-preview&ajax_loading=true"
    ).then (respond)->
      eval respond.data
]