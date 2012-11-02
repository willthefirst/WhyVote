Array::merge = (other) -> Array::push.apply @, other

HomeController = ($scope, $window, $location, $http) ->
  $scope.active_sorts = []
  $scope.current_sort_length = null
  $scope.current_candidate = null

  $scope.select_submit = ->
    window.scrollTo(0,0)
    angular.element('#posts').hide()
    angular.element('#submit').fadeIn()

  $scope.select_candidate = (candidate) ->
    $scope.candidate = candidate
    angular.element('.candidate').removeClass('selected')
    angular.element('#' + candidate).addClass('selected')
    angular.element('.candidate').hide()
    angular.element('.selected').show()

  $scope.select_close = ->
    angular.element('.disclaimer').fadeOut()

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
        angular.element('section#submit').hide()
        angular.element('.call-to-action, .fixed-button').hide()
        angular.element('.disclaimer').show()
        angular.element('section#posts').fadeIn()
        window.scrollTo(0,0)

        rsp.post.votes = 1
        $scope.posts.unshift rsp.post


  $scope.vote = (post) ->
    $http.post('/vote', { post: post, fingerprint: jQuery.fingerprint() }).success (rsp) ->
      if rsp.success
        votes = angular.element('#post' + post.id).find('.votes')
        num = parseInt(votes.attr('orig')) + 1
        votes.html num

  $scope.sort = (sort) ->
    remove = ->
      $scope.active_sorts = _.reject $scope.active_sorts, (asort) -> asort.name == sort.name
      $scope.posts = $scope.all_posts
      $scope.posts = asort.sort_function() for asort in $scope.active_sorts

    switch sort.type
      when 'order'
        if _.any($scope.active_sorts, (asort) -> asort.name == sort.name)
          remove()
        else
          $scope.active_sorts = _.reject $scope.active_sorts, (asort) -> asort.type == sort.type
          $scope.active_sorts.push sort
          $scope[sort.name].sort_function()
      when 'filter'
        remove()
        if sort.state_handler()
          $scope.active_sorts.push sort
          $scope.posts = sort.sort_function()
        
  $scope.best = {
    type: 'order'
    name: 'best'
    sort_function: -> $scope.posts = _.sortBy $scope.posts, (post) -> -post.popularity
  }

  $scope.candidate = {
    type: 'filter'
    name: 'candidate'
    state_handler: ->
      $scope.current_candidate =
        switch $scope.current_candidate
          when null then 'obama'
          when 'obama' then 'romney'
          when 'romney' then 'johnson'
          when 'johnson' then null
    sort_function: ->
      $scope.posts = _.filter $scope.posts, (post) -> post.candidate == $scope.current_candidate
  }

  $scope.recent = {
    type: 'order'
    name: 'recent'
    sort_function: -> $scope.posts = _.sortBy $scope.posts, (post) -> -(moment post.created_at)
  }

  $scope.length = {
    type: 'filter'
    name: 'length'
    state_handler: ->
      $scope.current_sort_length =
        switch $scope.current_sort_length
          when null then 'twitter'
          when 'twitter' then 'opinion'
          when 'opinion' then 'discourse'
          when 'discourse' then null

    sort_function: ->
      $scope.posts = _.filter $scope.posts, (post) ->
        switch $scope.current_sort_length
          when 'twitter'
            post.reason.length <= 140
          when 'discourse'
            post.reason.length >= 400
          when 'opinion'
            post.reason.length > 140 && post.length < 400
  }

  $http.get('/posts.json?fingerprint=' + jQuery.fingerprint()).success (rsp) ->
    _.each rsp, (post) ->
      post.votes = _.filter(post.votes, (vote) -> vote.positive).length
      post.reason = post.reason[0].toLowerCase() + post.reason.slice(1, post.reason.length) unless post.reason[0] == 'I' || post.reason.slice(0,6) == 'Barack' || post.reason.slice(0, 5) == 'Obama' || post.reason.slice(0, 4) == 'Mitt' || post.reason.slice(0, 6) == 'Romney' || post.reason.slice(0, 4) == 'Gary' || post.reason.slice(0, 7) == 'Johnson' || post.reason.slice(0, 3) == 'God'
    $scope.all_posts = rsp
    $scope.posts     = rsp

angular.module('why-vote', ['ngCookies'])
  .directive('vote', -> (scope, element, attrs) ->
    votes = element.find '.votes'

    if $("html").hasClass("no-touch") 
      $(".hoverable").addClass "hover"

    if !Modernizr.touch
      element.on
        mouseenter: ->
          votes.attr('orig', votes.html())
          votes.html '<--'

        mouseleave: ->
          votes.html votes.attr('orig') if votes.html() == '&lt;--'
    else
      element.on
        touchstart: ->
          votes.attr('orig', votes.html())
  )
  .config([ '$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider.when('/',
      templateUrl: '/partials/home.html'
      controller: HomeController
    ).otherwise redirectTo: '/'
    $locationProvider.html5Mode true
  ])



