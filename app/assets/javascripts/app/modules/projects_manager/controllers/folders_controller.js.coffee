angular.module('projectsManager').controller 'FoldersCtrl', ['$scope', '$log', 'Folder', 'Project', ($scope, $log, Folder, Project) ->

  # init $scope
  $scope.current =
    data:         null
    showDialogId: null
  $scope.folders = Folder.query {}, ->
    if $scope.search.length > 0
      $scope.found = Project.query search: $scope.search, ->
        $scope.folders.insert
          id: 'search'
          name: 'search'
          parent_id: null
          projects_count: $scope.found.length
          subfolders: []
        , 0
        $scope.current.data = $scope.folders[0]
    else
      $scope.current.data = $scope.folders[0]

  $scope.$watch ->
    $scope.current.data
  , ->
    if $scope.current.data and $scope.current.data.id != 'search'
      $scope.folders.remove (f) -> f.id == 'search'
    $scope.$broadcast 'folderChanged'

  # methods
  $scope.showSubfolderDialog = ->
    $scope.showDropdownFlag = false
    if $scope.current.data.name != 'uncategorized' and not $scope.current.data.parent_id?
      $scope.current.showDialogId = $scope.current.data.id

  $scope.saveFolder = ->
    folder = Folder.save name: $scope.newFolderName, ->
      $scope.folders.push folder
      $scope.current.showDialogId = null
      $scope.newFolderName = null
      # hack for updating list of folders
      angular.element($("select[selectpicker].folders-list")).scope().destFolderId = Math.random(500,600)

  $scope.onFolderRemove = (folder) ->
    unless folder.parent_id
      $scope.folders.remove (f) -> f.id == folder.id
    if folder.id == $scope.current.data.id
      if folder.parent_id
        $scope.current.data = $scope.folders.find (f) -> f.id == folder.parent_id
      else
        $scope.current.data = $scope.folders[0]
]
