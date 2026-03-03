class RollCallEntriesController < ApplicationController
  # Pas d'authentification : la page est publique pour les étudiants

  def new
    @roll_call_entry = RollCallEntry.new
  end

  def create
    @roll_call_entry = RollCallEntry.new(roll_call_entry_params)

    if @roll_call_entry.save
      redirect_to new_roll_call_entry_path, notice: "Merci, votre présence a été enregistrée."
    else
      flash.now[:alert] = "Merci de renseigner votre prénom et votre nom."
      render :new, status: :unprocessable_entity
    end
  end

  # Page prof : simple liste de tous les étudiants qui se sont enregistrés
  def index
    @roll_call_entries = RollCallEntry.order(created_at: :asc)
  end

  private

  def roll_call_entry_params
    params.require(:roll_call_entry).permit(:first_name, :last_name)
  end
end

