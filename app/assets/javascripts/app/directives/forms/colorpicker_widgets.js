'use strict';

angular.module('optimizePlayer').directive('colorpickerWidgets', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function($scope, $element, $attrs, ngModel) {

      setTimeout(function() {

        $element[0].onchange = function(e) {
          if(e.target.value === "") {
            e.target.style.color = "";
            e.target.style["background-color"] = "";
          }
        };

        $element[0].onclick = function(e) {
          e = e || window.event;
          colorPicker(e);
          colorPicker.cP.style.zIndex = 5000;
          colorPicker.cP.style.left = '-180px';
          colorPicker.exportColor = function() {

          ngModel.$setViewValue($element[0].value);
          $scope.$apply();

          };
          if(e.target.value === "") {
            e.target.style.color = "";
            e.target.style["background-color"] = "";
          }
        };

        ngModel.$formatters.push(function(s) {
          var rgba, color = {};
          if (typeof s == "string") {
            rgba = s.split(",");
            rgba  = [rgba[0], rgba[1], rgba[2]];
          }
          else
            rgba = s;
          return $.Color().rgba(rgba).toHexString();
        });

        ngModel.$parsers.push(function(s) {
          var red, green, blue;
          var color = $.Color(s);
          return color.toHexString();
        });
      }, 0);

    }
  };
});