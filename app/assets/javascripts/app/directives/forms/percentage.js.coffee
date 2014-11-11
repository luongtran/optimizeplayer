"use strict"
angular.module("optimizePlayer").directive "percentage", ->
  restrict: "A"
  require: "ngModel"
  link: ($scope, $element, $attrs, ngModel) ->
    ngModel.$formatters.push (value) ->
      result = if value == undefined then 0 else (value * 100)        
      result + "%"


