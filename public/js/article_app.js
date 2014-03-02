var articleApp = angular.module('articleApp', ['ngRoute', 'articleControllers', 'ui.bootstrap']);
 
/*articleApp.controller('ArticleListCtrl', function ($scope, $http) {
	$http.get('/articles/articles.json').success(function(data) {
		$scope.articles = data;
	});
});*/

articleApp.config(['$routeProvider',
	function($routeProvider) {
		$routeProvider.
		when('/articles', {
			templateUrl: 'article-list.html',
			controller: 'ArticleListCtrl'
		}).
		when('/article', {
			templateUrl: 'article-detail.html',
			controller: 'ArticleDetailCtrl'
		}).
		when('/article/add', {
			templateUrl: 'article-new.html',
			controller: 'ArticleNewCtrl'
		}).
		when('/article/edit/:articleid', {
			templateUrl: 'article-new.html',
			controller: 'ArticleEditCtrl'
		}).
		otherwise({
		redirectTo: '/articles'
	});
}]);


