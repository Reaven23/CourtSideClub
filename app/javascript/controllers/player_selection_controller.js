import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "counter"]

  connect() {
    this.updateCounter()
  }

  togglePlayer(event) {
    // Si on clique sur la carte, basculer la checkbox
    if (event.target.closest('.card') && !event.target.matches('input[type="checkbox"]')) {
      const checkbox = event.target.closest('.card').querySelector('input[type="checkbox"]')
      if (checkbox) {
        checkbox.checked = !checkbox.checked
        this.updateCounter()
      }
    }
  }

  updateCounter() {
    if (this.hasCounterTarget) {
      const checkedCount = this.checkboxTargets.filter(cb => cb.checked).length
      const text = checkedCount === 1 ? '1 joueur sélectionné' : `${checkedCount} joueur(s) sélectionné(s)`
      this.counterTarget.textContent = text
    }
  }
}
