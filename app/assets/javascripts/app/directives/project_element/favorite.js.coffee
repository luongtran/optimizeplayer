angular.module('optimizePlayer').directive 'projectFavorite', ->
  restrict: 'E'
  templateUrl: '/assets/project_element/favorite.html'
  scope:
    project:  '=project'
    onUpdate: '&onUpdate'
  replace: true
  controller: ['$scope', '$element', ($scope, $element) ->
    $scope.favoriteClass = ->
      if $scope.project.favorite
        'favorite-on'
      else
        'favorite-off'

    $scope.favorToggle = ->
      $scope.project.favorite = not $scope.project.favorite
      $scope.project.$toggleFavorite ->
        if $scope.onUpdate()
          $scope.onUpdate()($scope.project)
  ]
