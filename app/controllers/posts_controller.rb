class PostsController < ApplicationController

  rescue_from Exception do |e|
    # log.error "#{e.message}"
    render json: {error: e.message}, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    render json: @posts, status: :ok
  end
  

  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

  def create
    @post = Post.create!(create_params)
    render json: @post, status: :created
  end

  def update
    @post = Post.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok

  end
  
  private
    def create_params
      params.require(:post).permit(:title, :content, :published, :user_id)
    end

    def update_params
      params.require(:post).permit(:title, :content, :published)
    end
end