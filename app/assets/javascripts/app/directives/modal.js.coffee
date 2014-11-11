angular.module("optimizePlayer").directive "modal", ->
  link: ($scope, $element, $attrs) ->
    $(".close-modal", $element).click ->
      $element.foundation "reveal", "close"
