angular.module('metaLogin')
    .controller('UserCtrl', [
        '$scope',
        '$state',
        '$auth',
        '$http',
        function($scope, $state, $auth,$http) {
          $auth.validateUser().then(function(user) {
            $scope.user = {}
            $scope.user = user
            $http.get('/users/'+ user.id +'/connected_accounts.json')
             .then(function(response) {
               console.log(response);
                $scope.user.connected_accounts = response.data
             });
          })

        }
    ]);
