import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "hiddenField", "counter"]

  connect() {
    this.selectedPlayers = new Set()
    this.initializeSelectedPlayers()
    this.updateCounter()
  }

  initializeSelectedPlayers() {
    // Si on est dans le formulaire d'édition, récupérer les joueurs déjà sélectionnés
    const selectedCards = this.cardTargets.filter(card => card.classList.contains('selected'))
    selectedCards.forEach(card => {
      const playerId = card.dataset.playerId
      this.selectedPlayers.add(playerId)
    })
    this.updateHiddenField()
  }

  togglePlayer(event) {
    const card = event.currentTarget
    const playerId = card.dataset.playerId

    console.log('Toggle player:', playerId)

    if (this.selectedPlayers.has(playerId)) {
      this.selectedPlayers.delete(playerId)
      card.classList.remove('selected')
      card.style.border = '1px solid #dee2e6'
      card.style.backgroundColor = ''
      console.log('Player removed:', playerId)
    } else {
      this.selectedPlayers.add(playerId)
      card.classList.add('selected')
      card.style.border = '2px solid #0d6efd'
      card.style.backgroundColor = '#f8f9fa'
      console.log('Player added:', playerId)
    }

    console.log('Selected players:', Array.from(this.selectedPlayers))
    this.updateHiddenField()
    this.updateCounter()
  }

  updateHiddenField() {
    if (this.hasHiddenFieldTarget) {
      // Créer des champs cachés multiples pour chaque joueur sélectionné
      this.updateMultipleHiddenFields()

      console.log('Multiple hidden fields created for players:', Array.from(this.selectedPlayers))
    } else {
      console.log('No hidden field target found')
    }
  }

  updateMultipleHiddenFields() {
    console.log('=== updateMultipleHiddenFields called ===')
    console.log('Selected players:', Array.from(this.selectedPlayers))

    // Supprimer les anciens champs cachés multiples
    const existingFields = this.hiddenFieldTarget.parentNode.querySelectorAll('input[name="vote_campaign[player_ids][]"]')
    console.log('Existing fields found:', existingFields.length)
    existingFields.forEach(field => field.remove())

    // Supprimer aussi le champ principal pour éviter les conflits
    if (this.hiddenFieldTarget) {
      console.log('Removing main hidden field')
      this.hiddenFieldTarget.remove()
    }

    // Créer un nouveau champ caché pour chaque joueur sélectionné
    this.selectedPlayers.forEach(playerId => {
      const newField = document.createElement('input')
      newField.type = 'hidden'
      newField.name = 'vote_campaign[player_ids][]'
      newField.value = playerId
      this.hiddenFieldTarget.parentNode.appendChild(newField)
      console.log('Created hidden field for player:', playerId)
    })

    // Vérifier que les champs ont bien été créés
    const finalFields = this.hiddenFieldTarget.parentNode.querySelectorAll('input[name="vote_campaign[player_ids][]"]')
    console.log('Final hidden fields count:', finalFields.length)
    finalFields.forEach(field => console.log('Field:', field.name, '=', field.value))
  }

  updateCounter() {
    if (this.hasCounterTarget) {
      const count = this.selectedPlayers.size
      const text = count === 1 ? '1 joueur sélectionné' : `${count} joueur(s) sélectionné(s)`
      this.counterTarget.textContent = text
      console.log('Counter updated to:', text)
    } else {
      console.log('No counter target found')
    }
  }
}
