class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    posts = Post.all
    posts.each do |post|
      user = User.find_or_create_by_fingerprint params[:fingerprint]
      unless post.votes.where(user_id: user.id).first
        vote = user.votes.create(positive: false)
        post.votes << vote
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: posts.sort_by{ |p| [p.popularity, p.created_at] }.to_json(include: :votes) }
    end
  end

  def vote
    post = Post.find params[:post][:id]
    user = User.find_or_create_by_fingerprint params[:fingerprint]
    prev_vote = post.votes.where(user_id: user.id).first
    unless prev_vote && prev_vote.positive
      prev_vote.destroy if prev_vote
      vote = current_user.votes.create(positive: true)
      post.votes << vote
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    # logger.debug"ERROR LOG = #{@user}"

    post = Post.new params[:post]
    user = User.find_or_create_by_fingerprint params[:user][:fingerprint]
    #post.legit = false if user.posts.first
    post.user = user
    vote = user.votes.create(positive: true)
    post.votes << vote
    
    respond_to do |format|
      if post.save
        format.html { redirect_to post, notice: 'Post was successfully created.' }
        format.json { render json: { success: true, post: post }, status: :created, location: post }
      else
        format.html { render action: "new" }
        format.json { render json: { success: false, errors: post.errors }, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def vote_up
    begin
      @post = Post.find(params[:id])

      current_user.vote_for(@post)

      respond_to do |format|
        format.js
      end

    rescue ActiveRecord::RecordInvalid
      render :nothing => true, :status => 404
    end

  end
end
