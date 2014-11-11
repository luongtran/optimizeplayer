"use strict"
angular.module("optimizePlayer").directive "customDimension", ->
  restrict: "A"
  require: "ngModel"
  link: ($scope, $element, $attrs, ngModel) ->
    
    ngModel.$parsers.push (s) ->
      if $scope.project
        if ngModel.$name == "custom_width"
          s = if parseInt(s) > 1280 then 1280 else parseInt(s)
          $element.val(s)
          $scope.project.custom_width = s
        else if ngModel.$name == "custom_height"
          s = if parseInt(s) > 1280 then 1280 else parseInt(s)
          $element.val(s)
          $scope.project.custom_height = s
