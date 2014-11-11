"use_strict"

angular.module("videopage")

  # .directive "wgIcons", ->
  #   restrict: 'C'
  #   template:
  #     """
  #       <div class="widget-buttons">
  #         <a class="remove" ng-click="removeWidget({{widget.id}}) prevent-default">
  #           <i class="icon-remove"></i>
  #         </a>
  #         <a class="edit" ng-click="editWidget('{{type}}',{{widget.id}}) prevent-default">
  #           <i class="icon-edit"></i>
  #             {{test}}
  #         </a>
  #       </div>
  #     """
  #   link: (scope, element, attrs)->
  #     scope.type = scope.widget.component.replace /wg/g, ''

  .directive "wgtitle", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgtitle.html"
    link: (scope, element, attrs) ->

.directive "wgvideoBox", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgvideobox.html"
    link: (scope, element, attrs) ->

  .directive "wgparagraph", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgparagraph.html"
    link: (scope, element, attrs) ->

  .directive "wgfbcomments", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgfbcomment.html"
    link: (scope, element, attrs) ->

  .directive "wgfblike", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgfblike.html"
    link: (scope, element, attrs) ->

  .directive "wgimage", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgimage.html"
    link: (scope, element, attrs) ->

  .directive "wghtml", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wghtml.html"
    link: (scope, element, attrs) ->

  .directive "wgbutton", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgbutton.html"
    link: (scope, element, attrs) ->

  .directive "wgtwitter", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgtwitter.html"
    link: (scope, element, attrs) ->

  .directive "wgdisqus", ->
    restrict: "A"
    scope: {}
    replace: true
    templateUrl: "/assets/wgdisqus.html"
    link: (scope, element, attrs) ->
