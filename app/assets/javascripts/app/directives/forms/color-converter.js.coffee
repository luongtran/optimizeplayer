"use strict"
angular.module("optimizePlayer").directive "colorConverter", ->
  restrict: "A"
  require: "ngModel"
  link: ($scope, $element, $attrs, ngModel) ->
    
    ngModel.$formatters.push (s) ->
      unless s is `undefined`
        rgba = undefined
        color = {}
        if typeof s is "string"
          rgba = s.split(",")
          rgba = [ rgba[0], rgba[1], rgba[2] ]
        else
          rgba = s
        color = $.Color().rgba(rgba).toHexString()
        color

    ngModel.$parsers.push (s) ->
      red = undefined
      green = undefined
      blue = undefined
      color = $.Color(s)
      red = color.red()
      green = color.green()
      blue = color.blue()
      red + "," + green + "," + blue
