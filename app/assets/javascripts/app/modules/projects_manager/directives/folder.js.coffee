# folder(model="folder" current="current" system="true" on-remove="method")
# current must be Object like {data: folder, showDialogId: null}
# on-remove is a method like (folderResource) -> blabla
angular.module('projectsManager').directive 'folder', ->
  restrict: 'E'
  templateUrl: '/assets/folder.html'
  scope:
    folder:         '=model'
    current:        '=current'
    system:         '&system'
    onRemove:       '&onRemove'
  replace: true
  controller: ['$scope', '$element', 'Folder',  ($scope, $element, Folder) ->
    $scope.view = (folder) ->
      $scope.current.showDialogId = null
      $scope.current.data = folder

    $scope.remove = (folder) ->
      # nested folders are just objects. Make it resource:
      target = if folder.parent_id
        new Folder(folder)
      else
        folder

      total_projects = target.projects_count

      if target.subfolders and target.subfolders.length > 0
        target.subfolders.each (x) ->
          total_projects += x.projects_count

      confirm_message = if total_projects > 0
        "This folder or its subfolders have projects in them. By confirming deletion the projects in these folders will also be deleted. Are you sure?"
      else
        'Are you sure?'

      if confirm(confirm_message)
        if target.parent_id
          $scope.folder.subfolders.remove (sf) -> sf.id == target.id
          if $scope.current.data.id == target.id
            $scope.current.data = $scope.folder
        else
          $element.remove()

        target.$remove()
        if $scope.onRemove()
          $scope.onRemove()(target)
        angular.element($("select[selectpicker].folders-list")).scope().destFolderId = Math.random(500,600)

    $scope.saveSubfolder = ->
      newFolder = Folder.save(name: $scope.newSubfolderName, parent_id: $scope.folder.id)
      $scope.folder.subfolders.push newFolder
      $scope.current.showDialogId = null
      $scope.newSubfolderName = null
      angular.element($("select[selectpicker].folders-list")).scope().destFolderId = Math.random(500,600)

    $scope.expandedId = ->
      if $scope.current.data
        $scope.current.data.parent_id or $scope.current.data.id
      else
        null
  ]
