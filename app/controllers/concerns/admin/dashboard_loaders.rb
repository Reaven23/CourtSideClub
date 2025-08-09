module Admin
  module DashboardLoaders
    extend ActiveSupport::Concern

    def load_users
      @users = User.order(created_at: :desc)
    end

    def load_articles
      @published_articles = Article.published.includes(:user, :tags, photo_attachment: :blob).recent
      @draft_articles = Article.draft.by_user(current_user).includes(:tags, photo_attachment: :blob).order(created_at: :desc)
      @new_article = current_user.articles.build
      @available_tags = Tag.alphabetical
    end

    def load_quiz_games
      @quiz_games = QuizGame.order(created_at: :desc)
      @new_quiz_game = QuizGame.new(active: false)
    end
  end
end
