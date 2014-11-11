angular.module("optimizePlayer").directive "overlayed", ->
  link: ($scope, $element, $attrs) ->
    $element.on("mouseenter", ->
      $(this).find(".overlay").stop().fadeIn 250
    ).on "mouseleave", ->
      $(this).find(".overlay").stop().fadeOut 250
