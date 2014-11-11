"use strict"
angular.module("optimizePlayer").directive "tabs", ->
  restrict: "E"
  scope: {}
  replace: true
  transclude: true
  controller: [
    "$scope"
    ($scope, $element) ->
      panes = $scope.panes = []
      $scope.select = (pane) ->
        angular.forEach panes, (pane) ->
          pane.selected = false
          return

        pane.selected = true
        return

      @addPane = (pane) ->
        $scope.select pane  unless panes.length
        panes.push pane
        return
  ]
  template: '<div>' +
              '<ul class="nav-tabs inline-list clearfix">' +
                '<li ng-repeat="pane in panes" ng-class="{active:pane.selected}">' +
                  '<a href="" ng-click="select(pane)">{{pane.title}}</a></li>' +
              '</ul>' +
              '<div class="tab-content clearfix" ng-transclude></div>' +
            '</div>'