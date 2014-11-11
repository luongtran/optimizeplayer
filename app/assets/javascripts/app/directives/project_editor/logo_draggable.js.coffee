"use strict"
angular.module("optimizePlayer").directive "logoDraggable", ->
  link: ($scope, $element, $attrs) ->

    $element
      .draggable({
        containment: ".inside",
        drag: (event, ui) ->

        start: (event, ui) ->

        stop: (event, ui) ->

      })