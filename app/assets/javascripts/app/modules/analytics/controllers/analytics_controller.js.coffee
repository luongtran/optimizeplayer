angular.module("analytics").controller "AnalyticsCtrl", ["$scope", "Analytics", ($scope, Analytics) ->
  $scope.analytics = Analytics;

  $scope.analytics.project_cid = $(".analytics-dashboard").data("project-cid") #FIXME
  $scope.analytics.project_duration = $(".analytics-dashboard").data("project-duration") #FIXME

  $scope.$watch 'analytics.project_cid', (cid) ->
    if cid
      $scope.analytics.pullEvents(cid).then (events) ->
        $scope.events = events
      $scope.analytics.pullViewers(cid)
]