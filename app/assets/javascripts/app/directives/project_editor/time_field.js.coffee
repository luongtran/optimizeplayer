angular.module('optimizePlayer').directive 'timeField', ['Helpers', (Helpers) ->
  restrict: 'A',
  require: 'ngModel',
  link: ($scope, element, attr, ngModel) ->

    element.bind "keypress", (e) ->
      char = String.fromCharCode(e.which || e.charCode || e.keyCode)

      if (element.val().match(":").length > 0 && char == ":") || !char.match(/[0-9]|:/g)
        e.preventDefault()
        
    ngModel.$parsers.push (text) ->
      milliseconds = Helpers.timeStringToMilliseconds(text)
      if milliseconds > optimizeplayer.player.getClip().duration*1000
        duration = optimizeplayer.player.getClip().duration*1000
        ngModel.$setViewValue( Helpers.millisecondsToTimeString(duration))
        ngModel.$render()
        return duration
      else
        return milliseconds

    ngModel.$formatters.push (s) ->
      Helpers.millisecondsToTimeString(s)
]