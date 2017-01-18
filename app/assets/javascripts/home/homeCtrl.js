angular.module('metaLogin').controller('MainCtrl', ['$scope', 'posts','postPromise',
function($scope, posts,postPromise) {
  
    $scope.posts = postPromise.data;

    $scope.addPost = function() {
        if (!$scope.title || $scope.title === '') {
            return;
        }
        posts.create({
            title: $scope.title,
            link: $scope.link,
        });
        $scope.title = '';
        $scope.link = '';
    };

    $scope.incrementUpvotes = function(post) {
        posts.upvote(post);
    };
}]);
