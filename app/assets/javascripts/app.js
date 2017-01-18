angular.module('metaLogin', ['ui.router', 'templates', 'ng-token-auth','ngRoute', 'ngResource',])
    .config([
        '$stateProvider',
        '$urlRouterProvider',
        '$authProvider',
        function($stateProvider, $urlRouterProvider,$authProvider) {
            $stateProvider
                .state('home', {
                    url: '/home',
                    templateUrl: 'home/_home.html',
                    controller: 'MainCtrl',
                    resolve: {
                        postPromise: ['posts', function(posts) {
                            return posts.getAll();
                        }]
                    }
                }).state('posts', {
                    url: '/posts/{id}',
                    templateUrl: 'posts/_posts.html',
                    controller: 'PostsCtrl',
                    resolve: {
                        post: ['$stateParams', 'posts', function($stateParams, posts) {
                            return posts.get($stateParams.id);
                        }]
                    }
                }).state('login', {
                    url: '/login',
                    templateUrl: 'auth/_login.html',
                    controller: 'AuthCtrl'
                })
                .state('register', {
                    url: '/register',
                    templateUrl: 'auth/_register.html',
                    controller: 'AuthCtrl',
                    onEnter: ['$state', '$auth', function($state, $auth) {
                        $auth.validateUser().then(function() {
                            $state.go('home');
                        })
                    }]
                })
                .state('user', {
                    url: '/user',
                    templateUrl: 'user/user.html',
                    controller: 'UserCtrl'
                });

            $urlRouterProvider.otherwise('home');
            $authProvider.configure({
                apiUrl: '.',
                omniauthWindowType: 'newWindow',
                authProviderPaths: {
                  facebook: '/auth/facebook',
                  google: '/auth/google_oauth2',
                  linkedin: '/auth/linkedin'
                },
                createPopup: function(url) {
                   return window.open(url, '_blank', 'closebuttoncaption=Cancel,width=600,height=600');
                 }
              });
        }
    ])

    angular.module('metaLogin').run(['$rootScope', '$auth', '$location', '$state', function($rootScope, $auth, $location, $state) {


      $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
          $auth.validateUser().then(function(response){
            var currentUser = response
            console.log(currentUser);
          },function(error){

          }
        );


      });

    }]);
