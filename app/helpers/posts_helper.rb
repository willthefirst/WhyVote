module PostsHelper
  def setup_post(post)
    post.user ||= User.new
    post
  end
end
