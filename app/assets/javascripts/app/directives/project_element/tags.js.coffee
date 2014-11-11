angular.module('optimizePlayer').directive 'projectTags', ->
  restrict: 'E'
  templateUrl: '/assets/project_element/tags.html'
  scope:
    project: '=project'
    sync:    '=sync'
  replace: true
  controller: ['$scope', '$element', 'Project', ($scope, $element, Project) ->

    $scope.addTag = ->
      tagsToAdd = $scope.newTags
      if tagsToAdd
        existingTags = $scope.project.tags.split(',').compact(true)
        tagsToAdd = tagsToAdd.split(',').compact(true)
        tagsToAdd.remove.apply(tagsToAdd, existingTags)
        tagsToAdd.each (tag) ->
          if existingTags.isEmpty()
            $scope.project.tags = tag
          else
            $scope.project.tags += ",#{tag}"
        Project.update id: $scope.project.id, tags: $scope.project.tags
      $scope.newTags = ''

    $scope.removeTag = (tag) ->
      $scope.project.tags = $scope.project.tags.split(',').compact(true).exclude(tag).join(',')
      Project.update id: $scope.project.id, tags: $scope.project.tags

    $scope.switch = ->
      if $scope.sync.tagsId == $scope.project.id
        $scope.sync.tagsId = null
      else
        $scope.sync.tagsId = $scope.project.id
  ]
