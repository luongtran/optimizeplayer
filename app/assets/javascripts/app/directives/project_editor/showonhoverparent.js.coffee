"use strict"
angular.module("optimizePlayer").directive "showonhoverparent", [ ->

  link: (scope, element, attrs) ->
    element.parent().bind "mouseenter", ->
      element.show()

    element.parent().bind "mouseleave", ->
      element.hide()
]
