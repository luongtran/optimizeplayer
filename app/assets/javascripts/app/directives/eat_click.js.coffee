angular.module('optimizePlayer').directive 'eatClick', ->
  (scope, element, attrs) ->
    element.on 'click', (e) ->
      e.preventDefault()

angular.module('optimizePlayer').directive 'preventDefault', ->
    link: (scope, element, attrs) ->
      if attrs.href == '#'
        element.on 'click', (e)->
          e.preventDefault()
          scope.$eval attrs.ngClick