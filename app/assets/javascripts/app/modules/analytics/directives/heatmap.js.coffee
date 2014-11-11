angular.module("analytics").directive "heatmap", ['Analytics', '$filter', (Analytics, $filter) ->
  restrict: 'E'
  scope: {
    viewer: "=viewer"
  },
  link: ($scope, $element, $attrs) ->
    
    $scope.segments = []

    $scope.$watch 'viewer', (viewer) ->
      Analytics.pullEvents(Analytics.project_cid, [{
        property_name: "session"
        operator: "eq"
        property_value: viewer
      },
      {
        property_name: "type",
        operator: "ne",
        property_value: "load"
      }
      ]).then (events) ->
        $scope.events = events
        $scope.buildSegments()


    $scope.buildSegments = ->
      ordered_events = $filter('orderBy')($scope.events, (a) -> if a.timestamp then a.timestamp else Date.parse(a.keen.timestamp))

      $scope.viewer_data = $scope.events[0]

      start  = $filter('filter')($scope.events, "start")
      finish = $filter('filter')($scope.events, "finish")
      pauses = $filter('filter')($scope.events, "pause")
      seeks  = $filter('filter')($scope.events, "seek")

      segments = []
      angular.forEach ordered_events, (event, i) ->
        if event.type == "start"
          segments.push(0)
        else if event.type == "pause"
          $scope.buildSegment event.time, event.time
          next_event = ordered_events[i+1]
          if segments.slice(-1)[0] != event.time && ordered_events[i-1].time != event.time &&
          (!next_event || 
          (next_event) &&
          (next_event.type != "pause" && next_event.type != "resume" && next_event.time != event.time && next_event.from != event.time))
            segments.push(event.time)
        else if event.type == "seek"
          segments.push(event.from)
          segments.push(event.time)
        else if event.type == "finish"
          segments.push(event.time)

      while segments.length > 0
        segment = segments.splice(0,2)
        Analytics.hours_watched += parseFloat(((segment[1] - segment[0])/3600).toFixed(2))
        $scope.buildSegment segment[0], segment[1]

    $scope.buildSegment = (start_time, end_time) ->
      gap = 480 / Analytics.project_duration
      left = start_time*gap
      width = if end_time && end_time != start_time
                end_time*gap - left
              else
                1
      $scope.segments.push {
        start_time: start_time,
        end_time: end_time,
        left: left,
        width: width
      }

]

