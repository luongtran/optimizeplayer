angular.module("optimizePlayer").directive "popup", ->
  link: ($scope, $element, $attrs) ->
    $(".help", $element).on("mouseenter", ->
      $(this).siblings(".popup-content").stop().fadeIn 250
      false
    ).on "mouseleave", ->
      $(this).siblings(".popup-content").stop().fadeOut 250
      false

