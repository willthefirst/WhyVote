Array::merge = (other) -> Array::push.apply @, other

HomeController = ($scope, $window, $location, $http) ->
  $scope.select_candidate = (candidate) ->
    $scope.candidate = candidate
    angular.element('.candidate').removeClass('selected')
    angular.element('#' + candidate).addClass('selected')
    angular.element('.candidate').hide()
    angular.element('.selected').show()

  $scope.submit = ->
    $http({
      method: 'POST'
      url: '/posts'
      data: $.param {
        post: { reason: @reason, candidate: @candidate }
        user: { fingerprint: jQuery.fingerprint() }
      }
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    }).success (rsp, status, headers) ->
      console.log rsp

angular.module('why-vote', ['ngCookies'])
  .directive('vote', -> (scope, element, attrs) ->
    votes = element.find '.votes'
    orig  = votes.html()
    element.on
      mouseenter: -> votes.html '<--'
      mouseleave: -> votes.html orig
  )
  .config([ '$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider.when('/',
      templateUrl: '/partials/home.html'
      controller: HomeController
    ).otherwise redirectTo: '/'
    $locationProvider.html5Mode true
  ])

