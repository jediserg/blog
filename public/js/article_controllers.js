var articleControllers = angular.module('articleControllers', ['ui.bootstrap']);

articleControllers.controller('ArticleListCtrl', ['$scope', '$http', '$window', '$location',
	function ($scope, $http, $window, $location) {
		$http.get('/admin/articleslist').success(function(data) {
			$scope.articles = data;
		});

		$scope.remove = function(id)
		{
			console.log("Remove article");
			$http({
				method 	: "GET",
				url  	: "/admin/removearticle/" + id
			}).success(function(data) {
				console.log("Article has been removed");

				for (var i = 0; i < $scope.articles.length; i++) 
				{
    				if ($scope.articles[i].url === id) {
      					$scope.articles.splice(i, 1);
      					break;
    				}
  				}

			}).error(function(data, status, headers, config) {
				console.log("Article has not been removed");
			});
		}

		$scope.edit = function(id)
		{
			console.log("Edit article:" + id);
			$location.path("article/edit/" + id)
		}

	}


]);
 
articleControllers.controller('ArticleDetailCtrl', ['$scope', '$routeParams',
	function ($scope, $routeParams) {
		$scope.phoneId = 5;
	}
]);

articleControllers.controller('ArticleNewCtrl', ['$scope', '$http', '$window', '$location',
	function ($scope, $http, $window, $location) {
		$scope.form = {};
		console.log("New article");
		$scope.processForm = function()
		{
			console.log($http);
			$http({
				method 	: "POST",
				url  	: "/admin/newarticle",
				data 	: $.param($scope.form),
				headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
			}).success(function(data) {
				$window.alert("Article has been saved");
				$location.path("/articles")
			});
		}
		$scope.save = function() 
		{
			$window.location.href = "/article/add";
		}	

		
	}
]);

articleControllers.controller('ArticleEditCtrl', ['$scope', '$http', '$window', '$location', '$routeParams',
	function ($scope, $http, $window, $location, $routeParams) {
		$scope.form = {};
		console.log("Edit article");

		$http.get('/admin/articleslist/' + $routeParams.articleid).success(function(data) {
			if(data)
			{
				if(data.length == 1)
				{
					$scope.form.title = data[0].title;
					$scope.form.url = data[0].url;
					$scope.form.content = data[0].content;
					$scope.form.description = data[0].description;
					$scope.form.preview = data[0].preview;
					$scope.form.keywords = data[0].keywords;
				}
			}
		});

		$scope.processForm = function()
		{
			console.log($http);
			$http({
				method 	: "POST",
				url  	: "/admin/newarticle",
				data 	: $.param($scope.form),
				headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
			}).success(function(data) {
				$window.alert("Article has been saved");
				$location.path("/articles")
			});
		}
		$scope.save = function() 
		{
			$window.location.href = "/article/add";
		}	

		
	}
]);
