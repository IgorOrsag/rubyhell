# doc
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @tags = sorted_tags
    @posts = Post.all.order('updated_at DESC')
    @posts.each(&:tags)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @tag = Tag.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @tag = Tag.new(name: @post.tag_names)
  end

  # GET /posts/filter/tag
  def filter
    @tags = sorted_tags
    @posts = Tag.where(name: params[:tag])[0].posts.order('updated_at DESC')
    @posts.each(&:tags)
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if !@tag[:name].empty? && @post.save
        @post.add_tags(@tag[:name])
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
      if @tag[:name].empty?
        @tag.save
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if !@tag[:name].empty? && @post.update_attributes(post_params)
        @post.add_tags(@tag[:name])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
      if @tag[:name].empty?
        @tag.save
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.tags.destroy_all
    @post.destroy
    Tag.all.each do |tag|
      tag.posts.empty? && tag.destroy
    end
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:author, :title, :body)
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def sorted_tags
    Tag.joins(:posts).group('tags.id').order('COUNT(*) DESC')
  end
end
