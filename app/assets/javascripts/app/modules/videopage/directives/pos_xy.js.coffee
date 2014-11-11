'use_strict'

angular.module('optimizePlayer')
  .directive( "posXy", [ 'dialogPosition', (dialogPosition) ->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs) ->
      element.on 'click', (e)->
        e.preventDefault()
        pos = $(@).offset()
        window_width = angular.element(window).width()
        window_height = angular.element(window).height()
        if pos.left >  window_width/2
          pos.left -= 300

        if pos.top >= window_height - 100
          pos.top -= 300
        dialogPosition.set pos
        setTimeout ->
          widget_height = angular.element('.custom-modal').height()
          if (pos.top + widget_height) > window_height
            angular.element("body").animate({scrollTop: element.offset().top + widget_height/10}, 'normal');
        ,100

  ])