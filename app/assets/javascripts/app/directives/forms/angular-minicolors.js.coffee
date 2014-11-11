"use strict"
angular.module "minicolors", []
angular.module("minicolors").provider "minicolors", ->
  @defaults =
    theme: "bootstrap"
    position: "bottom left"
    defaultValue: ""
    animationSpeed: 50
    animationEasing: "swing"
    change: null
    changeDelay: 0
    control: "hue"
    hide: null
    hideSpeed: 100
    inline: false
    letterCase: "lowercase"
    opacity: false
    show: null
    showSpeed: 100

  @$get = ->
    this

  return true

angular.module("minicolors").directive "minicolors", [ "minicolors", "$timeout", (minicolors, $timeout) ->
  require: "?ngModel"
  restrict: "A"
  priority: 1 #since we bind on an input element, we have to set a higher priority than angular-default input
  link: (scope, element, attrs, ngModel) ->
    inititalized = false
    
    #gets the settings object
    getSettings = ->
      config = angular.extend({}, minicolors.defaults, scope.$eval(attrs.minicolors))
      config

    
    #what to do if the value changed
    ngModel.$render = ->
      
      #we are already initialized
      unless scope.$$phase
        
        #not currently in $digest or $apply
        scope.$apply ->
          color = ngModel.$viewValue
          element.minicolors "value", color

      else
        
        #we are in digest or apply, and therefore call a timeout function
        $timeout (->
          color = ngModel.$viewValue
          element.minicolors "value", color
        ), 0

    
    #init method
    initMinicolors = ->
      return  unless ngModel
      settings = getSettings()
      
      # If we don't destroy the old one it doesn't update properly when the config changes
      element.minicolors "destroy"
      
      # Create the new minicolors widget
      element.minicolors settings
      
      # are we inititalized yet ?
      #needs to be wrapped in $timeout, to prevent $apply / $digest errors
      #$scope.$apply will be called by $timeout, so we don't have to handle that case
      unless inititalized
        $timeout (->
          color = ngModel.$viewValue
          element.minicolors "value", color
        ), 0
        inititalized = true
        return

    initMinicolors()
    
    #initital call
    
    # Watch for changes to the directives options and then call init method again
    scope.$watch getSettings, initMinicolors, true
 ]