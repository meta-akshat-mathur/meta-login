angular.module('metaLogin')
    .controller('NavCtrl', [
        '$scope',
        '$auth',
        '$state',
        '$rootScope',
        function($scope, $auth,$state,$rootScope) {
            $scope.signedIn;
            $scope.logout = function(){
              $auth.signOut()
                .then(function(resp) {
                  $scope.user = {};
                  $scope.signedIn = false;
                  $state.go('home')
                })
                .catch(function(resp) {
                  // handle error response
                });
            }

            $scope.$on('auth:login-success', function(e, user) {
                $scope.user = user;
                $scope.signedIn = true;
            });
            $scope.$on('auth:validation-success', function(e, user) {
                $scope.user = user;
                $scope.signedIn = true;
            });

            $scope.$on('auth:logout-success', function(e, user) {
                $scope.user = {};
                $scope.signedIn = false;
            });
            $scope.$on('auth:validation-error', function(e, user) {
                $scope.user = {};
                $scope.signedIn = false;

            });

        }
    ]);
