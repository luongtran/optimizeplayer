"use strict"
angular.module("videopage").directive "ngEditdrop", ->
  restrict: "A"
  scope: true
  link: (scope, element, attrs) ->