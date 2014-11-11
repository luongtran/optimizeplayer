"use strict"
angular.module("optimizePlayer").directive "cta", ['CtaStore', (CtaStore) ->
  link: ($scope, $element, $attrs) ->
    obj = $scope

    if $attrs.ngModel
      model = $attrs.ngModel.split(".")
      for i in model
        obj = obj[i]
    $scope.obj = obj

    $element.css
      top: $scope.obj.top
      left: $scope.obj.left

    $attrs.$observe "ngFullscreen", (val) ->
      if val == 'true'
        $('.draggable-form')
          .draggable({
            containment: '.inside',
            drag: (event, ui) ->
              if CtaStore.currentCta
                if CtaStore.currentCta.type == "CtaOptin"
                  true
                else
                  return false if CtaStore.currentCta.id != $scope.obj.id
              else
                false
            start: (event, ui) ->
            stop: (event, ui) ->
              $scope.setFullscreenPositions($(this), parseInt($('.draggable-form').css("left")), parseInt($('.draggable-form').css("top")))

          })
        # $scope.isdraggable = true
      else if val == 'false'
        $element
          .draggable({
            containment: '.inside',
            drag: (event, ui) ->
              if CtaStore.currentCta
                if CtaStore.currentCta.type == "CtaOptin"
                  true
                else
                  return false if CtaStore.currentCta.id != $scope.obj.id
              else
                false
            start: (event, ui) ->
            stop: (event, ui) ->
              $scope.setPositions($(this), parseInt($($element).css("left")), parseInt($($element).css("top")))
          })


    $attrs.$observe "ngResizable", (val) ->
      if val == 'true'
        $parent = $(this).closest('.inside')

        maxWidth = $parent.width()
        maxHeight = $parent.height()

        $element
          .resizable({
            handles: 'se',
            containment: ".inside",
            minHeight: 200,
            minWidth: 300,
            maxHeight: maxHeight,
            maxWidth: maxWidth
            stop: (event, ui) ->
              $scope.setSize($(this), $($element).width(), $($element).height())
          })
        $scope.isResizable = true
      else if $scope.isResizable
          $element.resizable("destroy")
          $scope.isResizable = false

    $scope.isFullscreen = ->
      $scope.obj.fullscreen == true || optin.fullscreen == 'true' || optin.position != 'inside'

    $scope.setPositions = ($elem, left, top) ->
      # $parent = $element.parent()
      $scope.$apply ->
        $scope.obj.left = left
        $scope.obj.top = top

    $scope.setFullscreenPositions = ($elem, fullscreen_left, fullscreen_top) ->
      console.log 
      $scope.$apply ->
        $scope.obj.fullscreen_left = fullscreen_left
        $scope.obj.fullscreen_top = fullscreen_top

    $scope.setSize = ($elem, width, height) ->
      # $parent = $element.parent()
      $scope.$apply ->
        $scope.obj.width = width
        $scope.obj.height = height
]
