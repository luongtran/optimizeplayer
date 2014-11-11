angular.module('optimizePlayer').directive 'accordion', ['$timeout', 'CtaStore', ($timeout, CtaStore) ->
  link: ($scope, element, attr, ctrl) ->
    $scope.active = false
    $scope.closedActiveTab = false
    $scope.minimized = false
    $scope.cta_store = CtaStore

    $scope.show = (tab) ->
      page = document.querySelector('#edit-project')
      page.classList.remove($scope.active)
      if $scope.active == tab
        $scope.active = false
      else
        page.classList.add(tab)
        $scope.active = tab
        if $scope.minimized == true
          $scope.minimized = false
          document.querySelector('a.accordion').click() #toggleTab is not called, only maximizing tab

    $scope.toggleTab = (val=undefined) ->
      if val != undefined
        $scope.minimized = val
      else
        $scope.minimized = !$scope.minimized

    $scope.$watch 'cta_store.currentCta', (val) ->
      $scope.active = false
    
    $scope.$watch 'minimized', (val) ->
      if val #minimize
        if $scope.active != false #there is active tab
          $scope.closedActiveTab = $scope.active #save active tab before minimize
          $scope.show($scope.active) #hide active tab
        else
          $scope.closedActiveTab = false
      else
        if $scope.closedActiveTab != false
          $scope.show($scope.closedActiveTab)
]