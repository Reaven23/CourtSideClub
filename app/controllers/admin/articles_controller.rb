class Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_article, only: [:edit, :update, :publish, :destroy]

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      if params[:commit] == 'publish'
        # Si une date de publication est définie, l'utiliser, sinon utiliser la date actuelle
        if @article.published_at.present?
          # La date est déjà définie, on ne fait rien
        else
          @article.publish!
        end
      end
      handle_tags if params[:article][:tag_names].present?
      redirect_to admin_dashboard_path(tab: 'articles'), notice: 'Article enregistré.'
    else
      flash[:alert] = @article.errors.full_messages.to_sentence
      redirect_to admin_dashboard_path(tab: 'articles'), status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      if params[:commit] == 'publish'
        if @article.published_at.present?
        else
          @article.publish! unless @article.published?
        end
      end
      handle_tags if params[:article][:tag_names].present?
      redirect_to admin_dashboard_path(tab: 'articles'), notice: 'Article mis à jour.'
    else
      flash.now[:alert] = @article.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    if @article.title.blank? || @article.content.blank?
      redirect_to admin_dashboard_path(tab: 'articles'), alert: 'Veuillez compléter le titre et le contenu avant de publier.'
      return
    end

    @article.publish!
    redirect_to admin_dashboard_path(tab: 'articles'), notice: 'Article publié avec succès !'
  end

  def destroy
    article_title = @article.title.presence || 'Article sans titre'

    if @article.destroy
      redirect_to admin_dashboard_path(tab: 'articles'), notice: "L'article '#{article_title}' a été supprimé avec succès."
    else
      redirect_to admin_dashboard_path(tab: 'articles'), alert: "Erreur lors de la suppression de l'article."
    end
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Vous n'avez pas les permissions nécessaires." unless current_user.admin?
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :youtube_embed, :instagram_embed, :photo, :tag_names, :published_at)
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
