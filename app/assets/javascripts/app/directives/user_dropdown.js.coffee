"use strict"
angular.module("optimizePlayer").directive "userDropdown", ->
  link: ($scope, $element, $attrs) ->
    dropdown = $element.find(".user-dropdown")
    toggl = $element.find(".open-user-dropdown")
    toggl.off 'click'
    toggl.on 'click', (event) ->
      dropdown.stop().slideToggle 250
      toggl.toggleClass "selected"
      $("body").on "click", ->
        dropdown.stop().slideToggle 250
        toggl.toggleClass "selected"
        $("body").off "click"
      false

