class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # Role permissions
  before_action :authenticate_user!, except: %i[ index show ]
  before_action only: %i[ edit update destroy] do
    authorize_request(["admin"])
  end

  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
    @comments = Comment.where(article_id: params[:id]).order(:created_at)

    reactions = Reaction.where(article_id: params[:id])
    reaction_type_count = Hash.new(0)
    reactions.pluck(:reaction_type).each do |reaction|
      reaction_type_count[reaction] += 1
    end
    @likes = reaction_type_count["like"]
    @dislikes = reaction_type_count["dislike"]

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

  # POST /articles/1
  def comment
    @comment = Comment.create(comment_params.merge(user_id: current_user.id, article_id: params[:id]))
    redirect_to article_path
  end

  def reaction
    @reaction_type = Reaction.create(reaction_params.merge(user_id: current_user.id, article_id: params[:id]))
    redirect_to article_path
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

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
