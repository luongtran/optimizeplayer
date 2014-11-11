"use strict"
angular.module("optimizePlayer").directive "shareButtons", ->
  restrict: 'A'
  link: ($scope, $element, $attrs) ->
    #init project from attributes if was not initialized
    unless $scope.project
      $scope.project = JSON.parse($attrs.project)