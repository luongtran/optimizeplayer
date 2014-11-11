# https://github.com/Robdel12/DropKick - sucks. Only for static
# dropkicks. It's the best integration with angular which i can make.
angular.module('optimizePlayer').directive 'ngDropkick', ->
  link: ($scope, $element, $attrs) ->
    $element.dropkick {
      change: (value) ->
        $("[name="+$(this).attr("name")+"]").val(value).trigger("change")
    }
    if $attrs.ngDropkickWatch
      $scope.$watch $attrs.ngDropkickWatch, (val) ->
        $element.prev().remove()
        $element.dropkick
          change: (value) ->
            $element.val(value).trigger("change")
      , true

