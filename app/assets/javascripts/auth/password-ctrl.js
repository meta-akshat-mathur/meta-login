angular.module('metaLogin')
    .controller('PasswordCtrl', [
        '$scope',
        '$state',
        '$auth',
        function($scope, $state, $auth) {
                $scope.handleUpdatePasswordBtnClick = function() {
                  $auth.updatePassword($scope.updatePasswordForm)
                    .then(function(resp) {
                      // handle success response
                      $state.go('home')
                    })
                    .catch(function(resp) {
                      // handle error response
                    });
                };
        }
    ]);
