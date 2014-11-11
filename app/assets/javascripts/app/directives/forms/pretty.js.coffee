"use strict"
angular.module("optimizePlayer").directive "pretty", ['$timeout', ($timeout) ->
  link: ($scope, $element, attrs) ->
    $element.find('input.pretty').prettyCheckable();
]

