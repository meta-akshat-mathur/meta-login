angular.module('metaLogin')
    .controller('AuthCtrl', [
        '$scope',
        '$state',
        '$auth',
        function($scope, $state, $auth) {

            $scope.login = function() {
              $auth.submitLogin($scope.user)
                .then(function(resp) {
                  $state.go('user');
                  console.log(resp);
                })
                .catch(function(resp) {
                  // handle error response
                });
                // Auth.login($scope.user).then(function() {
                //     $state.go('home');
                // });

              }
            $scope.register = function() {
              $auth.submitRegistration($scope.user)
                .then(function(resp) {
                  console.log(resp);
                  $state.go('user');
                })
                .catch(function(resp) {
                  // handle error response
                });
              };
                // Auth.register($scope.user).then(function() {
                //     $state.go('home');
                // });
                //
                $scope.socialLogin = function(provider) {
                  $auth.authenticate(provider).then(function(resp) {

                      $state.go('user');
                  })
                  .catch(function(resp) {
                    console.log(resp);

                  });

                };

                $scope.forgetPassword = function(){
                  $auth.requestPasswordReset($scope.user)
                    .then(function(resp) {
                      console.log(resp);
                      alert(resp.data.message);
                      // handle success response
                    })
                    .catch(function(resp) {
                      // handle error response
                    });
                }

                $scope.handleUpdatePasswordBtnClick = function() {
                  $auth.updatePassword($scope.updatePasswordForm)
                    .then(function(resp) {
                      // handle success response
                    })
                    .catch(function(resp) {
                      // handle error response
                    });
                };

        }
    ]);
