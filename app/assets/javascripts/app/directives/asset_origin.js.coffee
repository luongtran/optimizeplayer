angular.module("optimizePlayer").directive "assetOrigin", ->
  link: ($scope, $element) ->
    $scope.$watch "asset", (val) ->
      if val
        $element.on "change", ":radio", ->
          $radio = $(this)
          $radio.parents("li").addClass("selected").siblings("li.selected").removeClass "selected"
          $scope.$apply ->
            $scope.asset.file_origin = $radio.val()

        $element.find(":radio").prettyCheckable()
