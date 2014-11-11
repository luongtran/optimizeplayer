angular.module "opFilters", []

angular.module("optimizePlayerWidget", ['opFilters'])

angular.module("optimizePlayerWidget").config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")

  if optimizeplayer.embed
    $httpProvider.defaults.headers.common["X-User-Session"] = optimizeplayer.session.setKey()
]

angular.module("optimizePlayerWidget").controller("WidgetCtrl", ["$scope", "$http", "$timeout", "$rootScope",
  ($scope, $http, $timeout, $rootScope) ->

    $scope.init = (attrs, referer) ->
      $scope.project = attrs
      $rootScope.referer = referer

      $http.get("/api/v2/projects/#{$scope.project.cid}/ctas")
      .success (data) ->
        $scope.cta_store = data
        $timeout ->
          optimizeplayer.init($scope.project, data, referer)
        , 0

]);

######################################################################################################################
# Cta Purchase
######################################################################################################################
angular.module('optimizePlayerWidget').directive('purchase', ['$http', '$rootScope', ($http, $rootScope) ->
  link: ($scope, $element) ->

    $scope.email = ""

    if $scope.purchase.stripe_integration
      $scope.hide_stripe = false
    else
      $scope.hide_stripe = true

    $scope.hideStripe = (val)->
      $scope.hide_stripe = val

    $(document).on "purchaseSuccess", ->
      $scope.$apply ->
        $scope.deliverPurchase()

    $scope.$watch 'hide_stripe', (val) ->
      # stripe payment
      if $scope.purchase.stripe_integration
        $scope.stripe_form = $element.find(".stripe-form")
        Stripe.setPublishableKey $scope.purchase.stripe_integration.publishable_key
        $scope.stripe_form.submit (e) ->
          $scope.stripe_form.find('button').prop('disabled', true)
          Stripe.card.createToken($scope.stripe_form, $scope.stripeResponseHandler)
          return false

      # paypal payment
      if $scope.purchase.paypal_integration
        $paypal_form = $element.find(".paypal-form")
        $paypal_form.submit (e) ->
          payload = {
            cta_id: $scope.purchase.id,
            pi_id: $scope.purchase.paypal_integration_id,
            payment_info: {
              referer: $rootScope.referer,
              email: $scope.email
            }
          }

          $http.post($paypal_form.attr("action"), payload)
          .success (data) ->
            window.open(data.approval_url)
            $scope.purchase_id = data.purchase_id;
          return false

    # stripe callback
    $scope.stripeResponseHandler = (status, response) ->
      if (response.error)
        $scope.stripe_form.find('.payment-errors').text(response.error.message)
        $scope.stripe_form.find('button').prop('disabled', false)
      else
        token = response.id;
        $scope.stripe_form.append($('<input type="hidden" name="stripeToken" />').val(token))

        payload = {
          stripe_token: token,
          cta_id: $scope.purchase.id,
          pi_id: $scope.purchase.stripe_integration_id,
          payment_info: {
            referer: $rootScope.referer,
            email: $scope.email,
            fullname: $("[data-fullname]").val(),
            billing_zipcode: $("[data-zip]").val()
          }
        }

        $http.post($scope.stripe_form.attr("action"), payload)
        .success (data) ->
          $scope.purchase_id = data.purchase_id;
          $scope.deliverPurchase();
        .error (data) ->
          alert(data.errors)

    $scope.deliverPurchase = ->
      $http.post("/api/v2/purchase_callback", {purchase_id: $scope.purchase_id})
      .success (data) ->
        if (data.type == "link")
          alert(data.link)
        else if (data.type == "play_video")
          optimizeplayer.project.url = data.link
          optimizeplayer.initplayer()
          optimizeplayer.player.play()
      .then ->
        $element.hide()

]);


###########################################c###########################################################################
# Cta Survey
######################################################################################################################
angular.module('optimizePlayerWidget').directive('survey', ['$http', '$rootScope', ($http, $rootScope) ->
  link: ($scope, $element) ->

    $rootScope.current_question = $scope.survey.survey_questions_attributes[0]

    if $scope.survey.survey_questions_attributes.length == 1
      $rootScope.button_text = $scope.survey.button_text
    else
      $rootScope.button_text = "Next"

    $scope.proceedToNextOrSubmit = ->
      questions = $scope.survey.survey_questions_attributes
      if $("[name=survey_q#{$scope.current_question.id}_answer]:checked").val()
        current_index = questions.indexOf($scope.current_question)
        if current_index < questions.length - 1
          $rootScope.current_question = questions[current_index + 1]
        else if current_index == questions.length - 1
          option_ids = $.map($element.find("input:checked"), (el) -> $(el).val())
          payload = {
                      cta_id: $scope.survey.id,
                      option_ids: option_ids,
                      session_key: optimizeplayer.session.setKey()
                    }
          $http.post($element.attr("action"), payload)
          $rootScope.current_question = {text: "Thanks for filling out the survey.  Your responses are appreciated."}
          $scope.button_text = "Close survey"
      else
        optimizeplayer.hideCta($scope.survey)
]);


######################################################################################################################
# Cta Tag
######################################################################################################################
angular.module('optimizePlayerWidget').directive('tag', ['$http', ($http) ->
  link: ($scope, $element) ->
    $scope.tagVisible = false

    $scope.showTag = ->
      tag = $element.parent().find(".tag")
      if tag.hasClass("just-dragged")
        tag.removeClass("just-dragged")
      else
        $scope.tagVisible = true
        optimizeplayer.player.pause()
      true

    $scope.closeTag = ->
      $scope.tagVisible = false
      optimizeplayer.player.play()
]);

######################################################################################################################
# Cta Optin
######################################################################################################################
angular.module('optimizePlayerWidget').directive('optin', ['$http', ($http) ->
  link: ($scope, $element) ->
    $scope.optinVisible = true
    $scope.loading = false
    $scope.subscribe = ->
      payload = {
        cta_id: $scope.optin.id,
        email: $scope.email,
      }
      url = $element.data($scope.optin.provider + '-action')
      $scope.loading = true
      $http.post(url, payload).then((response) ->
        $scope.loading = false;
        $scope.optinForm.$setPristine()
        if response.data == ' '
          $scope.optinVisible = false
          if optimizeplayer.project.auto_start is "autoplay"
            optimizeplayer.player.resume()
        else
          $scope.api_error = response.data
        return
      )
      return
]);
