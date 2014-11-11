"use strict"
angular.module("optimizePlayer").directive "optinskipbtn", [ ->

  link: ($scope, $element, $attrs) ->
    #redeclare _player.js code
    setTimeout ->
      $('.skip-btn')[0].onclick = null
      $element.bind 'click', (e) ->
        el = $(@).parent().parent()
        unless el.hasClass "cta-preview"
          @parentNode.parentNode.style.display = 'none'
          optimizeplayer.player.resume()
    ,500    
]