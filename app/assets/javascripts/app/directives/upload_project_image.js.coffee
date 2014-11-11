angular.module('optimizePlayer').directive 'uploadProjectImage', ['$rootScope', '$http', '$timeout', '$sce', ($rootScope, $http, $timeout, $sce) ->
  restrict: 'E'
  templateUrl: '/assets/csn_direct_upload.html'
  scope:
    onAdd:            '&onAdd'
    onProgressChange: '&onProgressChange'
    onDone:           '&onDone'
    onFail:           '&onFail'
    csn:              '=csn' # if undefined - $rootScope.csn used
  replace: true
  link: ($scope, $element, $attrs) ->
    rightScope = if $attrs.csn
      $scope
    else
      $rootScope

    rc_type = if $attrs.rcType
                $attrs.rcType
              else
                'streaming'

    refresh = (after, data) ->
      $scope.hidden_inputs = []
      $http.get "/api/v1/assets/upload_form_params.json?filename=#{$scope.filename}&csn_id=#{rightScope.csn.id}"
      .success (response) ->
        $scope.action = $scope.trustUrl(response.action)
        $scope.hidden_inputs = response.hidden_inputs
        after() if after
        if $attrs.autoUpload
          $timeout ->
            data.submit()
          , 1

    $scope.trustUrl = (src) ->
      return $sce.trustAsResourceUrl(src);

    $element.fileupload angular.extend(
      dropZone: $($element.parent())
      add: (e, data) ->
        $scope.filename = data.files[0].name
        refresh ->
          if $scope.onAdd()
            $scope.onAdd()(data)
        , data

      start: (e, data) ->
        $(window).bind 'beforeunload', ->
          return 'You are uploading a video, if you leave this page the process will be interrupted.';

      progressall: (e, data) ->
        $scope.$apply ->
          percentage = parseInt(data.loaded / data.total * 100, 10)
          $scope.onProgressChange(percentage)

      done: (e, data) ->
        $(window).unbind 'beforeunload'
        $scope.$apply ->
          remote_url = data.result.childNodes[0].childNodes.item('Location').childNodes[0].data # get remote url from responce XML (S3)
          console.log $scope
          if $scope.$parent.onDone()
            $scope.$parent.onDone(remote_url)
          else
            $scope.onDone(remote_url)

      fail: (e, data) ->
        $(window).unbind 'beforeunload'
        if data.textStatus == "parsererror" # dirt hack to detect rackspace response
          $.getJSON "/api/v1/assets/rackspace_url.json?filename=op-#{data.files[0].name}&csn_id=#{rightScope.csn.id}&type=#{rc_type}", (response) ->
            $scope.$apply ->
              remote_url = response.url
              $scope.onDone(remote_url)
        else
          $scope.$apply ->
            $scope.onFail(data.messages)
    ,
      dataType: "xml"
    )
]
