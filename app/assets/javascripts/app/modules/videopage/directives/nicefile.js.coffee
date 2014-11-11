"use strict"
angular.module("videopage").directive "nicefile", ->
  restrict: "A"
  scope: true
  link: (scope, element, attrs) ->
    element.niceFileInput
      width:  '308'
      height: '30'
      btnText: 'Browse'
      btnWidth: '75'
      margin: '14'