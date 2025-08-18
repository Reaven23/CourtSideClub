// Script simple pour améliorer l'expérience de sélection des joueurs
// Sans utiliser Stimulus

document.addEventListener('DOMContentLoaded', function() {
  const playerSelectionForm = document.querySelector('.player-selection-form');

  if (playerSelectionForm) {
    const checkboxes = playerSelectionForm.querySelectorAll('input[type="checkbox"]');
    const counter = createCounter();

    // Ajouter le compteur au formulaire
    playerSelectionForm.querySelector('.form-text').after(counter);

    // Écouter les changements sur les checkboxes
    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', updateCounter);

      // Améliorer l'expérience utilisateur
      const card = checkbox.closest('.card');
      if (card) {
        card.addEventListener('click', function(e) {
          // Ne pas déclencher si on clique sur la checkbox elle-même
          if (e.target !== checkbox) {
            checkbox.checked = !checkbox.checked;
            checkbox.dispatchEvent(new Event('change'));
          }
        });
      }
    });

    // Initialiser le compteur
    updateCounter();
  }

  function createCounter() {
    const counter = document.createElement('div');
    counter.className = 'mb-2';
    counter.innerHTML = '<span class="badge bg-info" id="player-counter">0 joueur(s) sélectionné(s)</span>';
    return counter;
  }

  function updateCounter() {
    const playerSelectionForm = document.querySelector('.player-selection-form');
    if (!playerSelectionForm) return;

    const checkboxes = playerSelectionForm.querySelectorAll('input[type="checkbox"]');
    const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;
    const counter = playerSelectionForm.querySelector('#player-counter');

    if (counter) {
      const text = checkedCount === 1 ? '1 joueur sélectionné' : `${checkedCount} joueur(s) sélectionné(s)`;
      counter.textContent = text;
    }
  }
});
