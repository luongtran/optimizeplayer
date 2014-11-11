angular.module("optimizePlayer").directive "modalSubmit", ->
  link: ($scope, $element) ->
    $element.on "click", (e) ->
      e.preventDefault()
      $("#modal-csn a.close-reveal-modal").click()
