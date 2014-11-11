angular.module('optimizePlayer').directive 'projectFiles', ->
  restrict: 'E'
  templateUrl: '/assets/project_element/files.html'
  scope:
    project:  '=project'
    sync:     '=sync'
  replace: true
  controller: ['$scope', ($scope) ->
    $scope.switch = ->
      if $scope.sync.filesId == $scope.project.id
        $scope.sync.filesId = null
      else
        $scope.sync.filesId = $scope.project.id
  ]
