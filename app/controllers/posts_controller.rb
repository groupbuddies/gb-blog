class PostsController < ApplicationController
  decorates_assigned :posts, :post

  def index
    @posts = Post.recent.published
  end

  def search
    @query = search_params[:q]
    @posts = Post.search(@query, size: 20).records.published
  end

  def feed
    @posts = Post.published.recent

    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  def show
    @post = Post.find(params[:id])
    authorize! :read, @post
  end

  private

  def search_params
    params.require(:search).permit(:q)
  end
end
