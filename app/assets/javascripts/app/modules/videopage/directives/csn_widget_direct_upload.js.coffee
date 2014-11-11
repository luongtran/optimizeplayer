angular.module('videopage').directive 'csnWidgetDirectUpload', ->
  restrict: 'E'
  templateUrl: '/assets/csn_widget_direct_upload.html'
  scope:
    onAdd:            '&onAdd'
    onProgressChange: '&onProgressChange'
    onDone:           '&onDone'
    csn:              '=csn'
  replace: true
  link: ($scope, $element, $attrs) ->
    refresh = (after) ->
      $scope.hidden_inputs = []
      $.getJSON "/api/v1/assets/upload_form_params.json?filename=#{$scope.filename}&csn_id=#{$scope.csn.id}", (response) ->
        $scope.$apply ->
          $scope.action = response.action
          $scope.hidden_inputs = response.hidden_inputs
          after() if after

    $scope.$watch 'csn', ->
      if $scope.filename
        refresh()

    $element.fileupload angular.extend(
      add: (e, data) ->
        $scope.filename = data.files[0].name
        refresh ->
          $scope.onAdd()(data)

      progressall: (e, data) ->
        $scope.$apply ->
          percentage = parseInt(data.loaded / data.total * 100, 10)
          $scope.onProgressChange()(percentage)

      done: (e, data) ->
        $scope.$apply ->
          remote_url = data.result.childNodes[0].childNodes.item('Location').childNodes[0].data # get remote url from responce XML (S3)
          if $attrs.isbutton and $attrs.isbutton is "1"
            $scope.onDone()(remote_url,'custom_buttom')
          else
            $scope.onDone()(remote_url)

      fail: (e, data) ->
        if data.textStatus == "parsererror" # dirt hack to detect rackspace response
          $.getJSON "/api/v1/assets/rackspace_streaming_url.json?filename=op-#{data.files[0].name}&csn_id=#{$scope.csn.id}", (response) ->
            $scope.$apply ->
              remote_url = response.url
              $scope.onDone()(remote_url)
        else
          alert 'Upload failed'

    ,
      dataType: "xml"
    )

