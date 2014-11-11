angular.module('optimizePlayer').directive 'cuepoints', ['$timeout', ($timeout) ->
  restrict: 'A',
  link: ($scope, $element, $attrs, ctrl) ->

    $scope.$watch "cta_store.currentCta.on_cuepoints", (val) ->
      if !$scope.isTrue(val)
        $scope.cta_store.currentCta.cuepoints = []
      else if $scope.cta_store.currentCta.cuepoints.length == 0
        $scope.addCuepoint()
    , true

    $scope.addCuepoint = ->
      $scope.cta_store.currentCta.cuepoints.push([0,0])

    $scope.togglePause = (cuepoint) ->
      if typeof cuepoint[1] != "boolean"
        cuepoint[1] = false
      else
        cuepoint[1] = 0

    $scope.removeCuepoint = (index) ->
      if confirm "Are you sure?"
        $scope.cta_store.currentCta.cuepoints.splice(index, 1)

 ]
