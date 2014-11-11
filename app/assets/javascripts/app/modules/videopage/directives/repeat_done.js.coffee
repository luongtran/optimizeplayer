angular.module("videopage").directive 'repeatDone', ->
  link: (scope, elem, attrs, controller) ->
    # console.log '::Element::', elem
    if scope.$last
      # console.log 'Last element', elem
      setTimeout ->
        scope.$emit 'repeatDone',
        element:elem
        attrs: attrs
      , 0