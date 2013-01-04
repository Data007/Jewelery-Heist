function HelloController($scope, $http) {
  $scope.session = {authenticated: false, token: ''};
  $scope.responseText = '';
  $scope.items  = [];
  $scope.errors = [];

  $scope.getResponse = function() {
    $http.get('/angular_tests/hello_angular')
      .success(function(data, status, handlers, config) {
        $scope.responseText = data;
      })
      .error(function(data, status, handlers, config) {
        console.log('data: ' + data + ', status: ' + status);
      });
  };

  $scope.authenticate = function() {
    $http.get('/angular_tests/authenticate')
      .success(function(data, status, handlers, config) {
        $scope.session = data;
      })
      .error(function(data, status, handlers, config) {
        console.log('data: ' + data + ', status: ' + status);
      });
  };

  $scope.getItems = function() {
    $http.get('/angular_tests/items?token=' + $scope.session.token)
      .success(function(data, status, handlers, config) {
        $scope.errors = [];
        $scope.items = data;
      })
      .error(function(data, status, handlers, config) {
        if(status == 401){
          $scope.errors.push(data);
          console.log($scope.errors);
        }
        console.log('data: ' + data + ', status: ' + status);
      });
  };
}
