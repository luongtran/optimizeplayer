'use_strict'

theapp = angular.module('optimizePlayer')

# theapp.directive 'fbLike', ([ '$timeout', ($timeout)->
#   restrict: 'C'
#   link: (scope, element, attributes) ->
#     $timeout ->
#       FB?.XFBML.parse(element.parent()[0])
#     , 0
# ])


# theapp.directive 'fbComments', ([ '$timeout', ($timeout)->
#   restrict: 'C'
#   link: (scope, element, attributes) ->
#     $timeout ->
#       FB?.XFBML.parse(element.parent()[0])
#     , 0
# ])


createDirective = (name) ->
  theapp.directive name, ([ '$timeout', ($timeout)->
    restrict: 'C'
    link: (scope, element, attributes) ->
      $timeout ->
        FB?.XFBML.parse(element.parent()[0])
      , 0
  ])
createDirective pluginName for pluginName in ['fbActivity', 'fbComments', 'fbFacepile', 'fbLike', 'fbLikeBox', 'fbLiveStream', 'fbLoginButton', 'fbName', 'fbProfilePic', 'fbRecommendations']
