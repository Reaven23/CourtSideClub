class AdminDashboardPolicy < ApplicationPolicy
  def index?
    user&.admin?  # Seuls les admins peuvent voir le dashboard
  end

  # Pas besoin du Scope pour l'instant
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.none  # On ne liste rien sur le dashboard
    end
  end
end
