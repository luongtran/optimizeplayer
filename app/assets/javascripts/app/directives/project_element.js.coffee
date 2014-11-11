angular.module('optimizePlayer').directive 'projectElement', ['$filter', ($filter) ->
  restrict: 'E'
  templateUrl: '/assets/project_element.html'
  scope:
    project:      '=project'
    sync:         '=sync'
    selectedIds:  '=selectedIds'
    favoritesResort: '&favoritesResort'
  replace: true
  controller: ['$scope', '$element', '$timeout', 'Project', ($scope, $element, $timeout, Project) ->
    $scope.$on 'dropSelection', ->
      $scope.selected = false

    $scope.clickOnProject = ->
      project = $scope.project
      unless $scope.clickedOP
        $scope.clickedOP = $timeout ->
          $scope.clickedOP = null
          location.href = "/projects/#{project.cid}/edit"
        , 500

    $scope.dblclickOnProject = ->
      project = $scope.project
      $timeout.cancel $scope.clickedOP
      $scope.clickedOP = null
      $scope.nameEditing = true
      $scope.newTitle  = project.title

    $scope.updateProjectName = (p) ->
      project = if p then p else $scope.project
      if $scope.newTitle.length > 50
        alert("Project's title should not be longer than 50 characters")
        $scope.newTitle = $filter('limitTo')($scope.newTitle, 50)
        return
      else if $scope.newTitle and $scope.newTitle != project.title
        $scope.nameEditing = false
        project.title = $scope.newTitle
        Project.update(id: project.id, title: project.title)

    $scope.onFavoriteUpd = $scope.favoritesResort()

    $scope.clickOnEmbed = ->
      $("#classic-embed-link").val($scope.project.embedCode());
      new ZeroClipboard($(".clip_button"))
      $scope.currentProjectEmbed = $scope.project.embedCode()

    $scope.toggleIdInIds = ->
      if $element.find("input[type=checkbox]").is(':checked')
        $scope.selectedIds.push $scope.project.id
      else
        $scope.selectedIds.remove $scope.project.id
  ]
]
