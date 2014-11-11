angular.module('optimizePlayer').directive 'limitText', ->
  (scope, element, attrs) ->
    refresh = (maxWidth) ->
      if element.width() > maxWidth and element.is(':visible')
        unless element.attr('data-text-before')?
          element.attr 'data-text-before', element.text()
        text = element.text()
        while element.width() > maxWidth and text.length > 0
          text = text[..-2]
          element.text text + '...'
        element.attr 'title', element.attr('data-text-before')
      else
        element.removeAttr 'title'

    scope.$watch attrs.limitText, refresh

    if attrs.text
      scope.$watch attrs.text, (text) ->
        element.text text
        refresh attrs.limitText

    if attrs.refreshSwitch
      scope.$watch attrs.refreshSwitch, (x) ->
        refresh attrs.limitText if x

