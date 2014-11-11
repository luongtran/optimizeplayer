# A simple directive to display a gravatar image given an email
angular.module("optimizePlayer").directive "gravatar", [
  "md5"
  (md5) ->
    return (
      restrict: "E"
      template: "<img ng-src=\"http://www.gravatar.com/avatar/{{hash}}{{getParams}}\"/>"
      replace: true
      scope:
        email: "="
        size: "="
        defaultImage: "="
        forceDefault: "="

      link: (scope, element, attrs) ->
        generateParams = ->
          options = []
          scope.getParams = ""
          angular.forEach scope.options, (value, key) ->
            options.push key + "=" + encodeURIComponent(value)  if value

          scope.getParams = "?" + options.join("&")  if options.length > 0
        scope.options = {}
        scope.$watch "email", (email) ->
          scope.hash = md5(email.trim().toLowerCase())  if email

        scope.$watch "size", (size) ->
          scope.options.s = (if (angular.isNumber(size)) then size else `undefined`)
          generateParams()

        scope.$watch "forceDefault", (forceDefault) ->
          scope.options.f = (if forceDefault then "y" else `undefined`)
          generateParams()

        scope.$watch "defaultImage", (defaultImage) ->
          scope.options.d = (if defaultImage then defaultImage else `undefined`)
          generateParams()

    )
]