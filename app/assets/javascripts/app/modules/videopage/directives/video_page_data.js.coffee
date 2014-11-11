'use_strict'

angular.module('optimizePlayer')
  .directive "seoKeywords",([ 'videoPageData', (videoPageData) ->
    restrict: 'A'
    replace: true
    priority: 1
    link: (scope, element, attrs) ->
      seoObj = videoPageData.getSeo()

      setNewSeoObj = (obj) ->
        new_keyword = $.trim obj.val()
        new_keyword = new_keyword.replace(/\,+$/, '')
        if( new_keyword.length )
          seoObj.keywords.push new_keyword
          videoPageData.setSeo seoObj
          scope.$apply()
        obj.val('')

      element.on 'keyup', (e) ->
        if e.keyCode is 188
          setNewSeoObj( $(@) )

      element.on 'keypress', (e) ->
        if e.keyCode is 13
          setNewSeoObj( $(@) )
          e.preventDefault()

  ])