'use strict';

angular.module('optimizePlayer').directive('updatePlanForm', function() {
  return {
    link: function($scope, $element, $attrs) {
      $scope.stripeResponseHandler = function(status, response) {
        console.log('updating plan');
        console.log(response);
        if (response.error) {
          // Show the errors on the form
          $scope.$form.find('.payment-errors').text(response.error.message).addClass('text-danger');
          $scope.$form.find('button').prop('disabled', false);
        } else {
          // token contains id, last4, and card type
          var token = response.id;
          // Insert the token into the form so it gets submitted to the server
          $scope.$form.append($('<input type="hidden" name="stripeToken" />').val(token));
          // and submit
          $scope.$form.get(0).submit();
        };
      }

      $element.submit(function(event) {
        $scope.$form = $(this);
        $scope.$form.find('.payment-errors').text('');
        // Disable the submit button to prevent repeated clicks
        $scope.$form.find('button').prop('disabled', true);

        Stripe.createToken($scope.$form, $scope.stripeResponseHandler);

        // Prevent the form from submitting with the default action
        return false;
      });

    }
  }
});
