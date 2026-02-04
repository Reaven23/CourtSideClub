class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :publish]
  before_action :set_article, only: [:show, :edit, :update, :publish]

  def index
    if user_signed_in?
      @published_articles = Article.published.includes(:user, :tags, photo_attachment: :blob).recent
      @draft_articles = current_user.articles.draft.includes(:tags, photo_attachment: :blob).order(created_at: :desc)
    else
      @published_articles = Article.published.includes(:user, :tags, photo_attachment: :blob).recent
      @draft_articles = []
    end
  end

  def show
    unless @article.published? || (user_signed_in? && @article.user == current_user)
      redirect_to root_path, alert: "Cet article n'est pas disponible."
      return
    end
  end

  def new
    @article = current_user.articles.build
    @available_tags = Tag.alphabetical
  end

  def create
    @article = current_user.articles.build(article_params)
    @available_tags = Tag.alphabetical

    if params[:commit] == 'draft'
      @article.save(validate: false)
      handle_tags if params[:article][:tag_names].present?

      redirect_to @article, notice: 'Article enregistré en brouillon !'
    else
      if @article.save
        @article.publish!
        handle_tags if params[:article][:tag_names].present?

        redirect_to @article, notice: 'Article publié avec succès !'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    unless @article.user == current_user
      redirect_to @article, alert: "Vous ne pouvez pas modifier cet article."
      return
    end

    @available_tags = Tag.alphabetical
  end

  def update
    unless @article.user == current_user
      redirect_to @article, alert: "Vous ne pouvez pas modifier cet article."
      return
    end

    if params[:commit] == 'draft'
      @article.update(article_params.merge(published_at: nil))
      handle_tags if params[:article][:tag_names].present?

      redirect_to @article, notice: 'Article enregistré en brouillon !'
    else # params[:commit] == 'publish'
      # Publier avec validations complètes
      if @article.update(article_params)
        @article.publish! unless @article.published?

        # Gérer les tags
        handle_tags if params[:article][:tag_names].present?

        redirect_to @article, notice: 'Article publié avec succès !'
      else
        @available_tags = Tag.alphabetical
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def publish
    unless @article.user == current_user
      redirect_to articles_path, alert: "Vous ne pouvez pas publier cet article."
      return
    end

    if @article.title.blank? || @article.content.blank?
      redirect_to edit_article_path(@article), alert: 'Veuillez compléter le titre et le contenu avant de publier.'
      return
    end

    if @article.publish!
      redirect_to article_path(@article), notice: 'Article publié avec succès !'
    else
      redirect_to articles_path, alert: 'Erreur lors de la publication de l\'article.'
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :youtube_embed, :instagram_embed, :photo)
  end

  def handle_tags
    tag_names = params[:article][:tag_names]

    if tag_names.is_a?(String)
      tag_names = tag_names.split(',').map(&:strip).reject(&:blank?)
    elsif tag_names.is_a?(Array)
      tag_names = tag_names.reject(&:blank?)
    end

    tags = tag_names.map do |name|
      Tag.find_or_create_by(name: name.strip.downcase)
    end

    @article.tags = tags
  end
end
