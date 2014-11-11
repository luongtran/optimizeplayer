angular.module("optimizePlayer").directive "expandableTable", ->
  link: ($scope, $element, $attrs) ->
    $element.on "click", ".download a", ->
      $(this).remove()
      $element.find(".hidden").removeClass "hidden"
      return
