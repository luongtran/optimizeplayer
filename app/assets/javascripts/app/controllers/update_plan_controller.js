angular.module('optimizePlayer').controller('UpdatePlanCtrl', function ($scope) {
    $scope.update_update_plan_form = function (plan_id, plan_name, type) {
        $_form_update_plan = $('#form-update-plan');
        $_form_update_plan.find("input[name='plan_id']").val(plan_id);
        $_form_update_plan.find("#selected-plan-name").text(plan_name);

        $_submitBtn = $_form_update_plan.find("button");
        if (type === 'upgrade') {
            $_submitBtn.removeClass('btn-warning');
            $_submitBtn.addClass('btn-primary');
            $_submitBtn.text('Upgrade');
        } else if (type === 'downgrade') {
            $_submitBtn.removeClass('btn-primary');
            $_submitBtn.addClass('btn-warning');
            $_submitBtn.text('Downgrade');
        }

        if (!$('.state-2').hasClass('toggle')) {
            $('.state-1').addClass('toggle');
        }
        $('.state-2').addClass('toggle');
    }
});