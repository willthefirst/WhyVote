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
        user: { fingerprint: jQuery.fingerprint(), email: @email }
      }
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    }).success (rsp, status, headers) ->
      if rsp.success
        angular.element('section#submit').fadeOut()
        angular.element('section#posts').fadeIn()
        $('body').scrollTop(0);

        rsp.post.votes = 1
        $scope.posts.unshift rsp.post


  $scope.vote = (post) ->
    $http.post('/vote', { post: post, fingerprint: jQuery.fingerprint() }).success (rsp) ->
      if rsp.success
        votes = angular.element('#post' + post.id).find('.votes')
        num = parseInt(votes.attr('orig')) + 1
        votes.html num
    ''

  $http.get('/posts.json?fingerprint=' + jQuery.fingerprint()).success (rsp) ->
    _.each rsp, (post) -> post.votes = _.filter(post.votes, (vote) -> vote.positive).length
    $scope.posts = rsp

angular.module('why-vote', ['ngCookies'])
  .directive('vote', -> (scope, element, attrs) ->
    votes = element.find '.votes'
    element.on
      mouseenter: ->
        votes.attr('orig', votes.html())
        votes.html '<--'

      mouseleave: ->
        votes.html votes.attr('orig') if votes.html() == '&lt;--'

      mousedown: ->
        votes.html '<--'
        votes.parent().toggleClass "voted novote"
        element.off()
  )
  .config([ '$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider.when('/',
      templateUrl: '/partials/home.html'
      controller: HomeController
    ).otherwise redirectTo: '/'
    $locationProvider.html5Mode true
  ])

