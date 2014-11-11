angular.module('optimizePlayer').directive 'styleField', ['Helpers', (Helpers) ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, element, attr, ngModel) ->

    element.bind "keypress", (e) ->
      char = String.fromCharCode(e.which || e.charCode || e.keyCode)
      if !char.match(/[0-9]|:/g)
        e.preventDefault()

    ngModel.$parsers.push (text) ->
      return text + attr.format

    ngModel.$formatters.push (text) ->
      return text.replace(attr.format, "")
]