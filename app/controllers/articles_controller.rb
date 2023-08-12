class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # Role permissions
  before_action :authenticate_user!, except: %i[ index show comment ]
  before_action only: %i[ edit update destroy] do
    authorize_request(["admin"])
  end

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  # GET /articles/1 or /articles/1.json
  def show
    @comments = Comment.where(article_id: params[:id]).order(:created_at)

    reactions = Reaction.where(article_id: params[:id])
    @reaction_count = Hash.new(0)
    reactions.pluck(:reaction_type).each do |reaction|
      @reaction_count[reaction] += 1
    end

    if user_signed_in?
      @user_reaction = reactions.pluck(:user_id, :reaction_type).select{ |ele| ele[0] == current_user.id }.dig(0,1)
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles/1 members
  def comment
    @comment = Comment.new(comment_params.merge(article_id: params[:id]))
    @comment.user_id = current_user.id if user_signed_in?

    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_path, notice: "Comment created." }
        format.json { redirect_to article_path(format: :json), status: :created, location: @article }
      else
        format.html { redirect_to article_path, flash: { error: @comment.errors.full_messages }}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def reaction
    @reaction = Reaction.new(reaction_params.merge(user_id: current_user.id, article_id: params[:id]))
    respond_to do |format|
      if @reaction.save
        format.html { redirect_to article_path, notice: "Reaction added." }
        format.json { redirect_to article_path(format: :json), status: :ok, location: @article }
      end
    end
  end

  # PATCH/PUT /articles/1 members

  def update_reaction
    @reaction = Reaction.find_by(article_id: params[:id], user_id: current_user.id)
    respond_to do |format|
      if @reaction.update(reaction_params)
        format.html { redirect_to article_path, notice: "Reaction updated." }
        format.json { redirect_to article_path(format: :json), status: :ok, location: @article }
      end
    end
  end

  # DELETE /articles/1 members

  def remove_reaction
    @reaction = Reaction.find_by(article_id: params[:id], user_id: current_user.id)
    @reaction.destroy

    respond_to do |format|
      format.html { redirect_to article_path, notice: "Reaction removed." }
      format.json { head :no_content }
    end
  end

  def delete_comment
    @comment = Comment.find(params[:comment_id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to article_path, notice: "Comment deleted." }
      format.json { head :no_content }
    end
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :image, :user_id)
    end

    def comment_params
      params.require(:comment).permit(:content)
    end

    def reaction_params
      params.permit(:reaction_type)
    end
end
