import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "startScreen", "gameScreen", "resultsScreen", "loadingScreen",
    "currentQuestion", "totalQuestions", "currentScore", "progressBar",
    "timerText", "questionImage", "questionText", "answersGrid",
    "feedbackModal", "feedbackIcon", "feedbackTitle", "feedbackText", "feedbackPoints",
    "finalScore", "correctAnswers", "totalAnswered",
    "levelUpNotification", "newLevel"
  ]

  static values = {
    quizId: Number
  }

      connect() {
    console.log("Quiz controller connecting...")
    console.log("Element dataset:", this.element.dataset)
    console.log("QuizId value:", this.quizIdValue)

    this.quizId = this.quizIdValue
    this.userQuizGameId = null
    this.questions = []
    this.currentQuestionIndex = 0
    this.score = 0
    this.timer = null
    this.timeLeft = 24
    this.isAnswered = false

    console.log("Quiz controller connected for quiz:", this.quizId)
  }

  disconnect() {
    this.clearTimer()
  }

  startQuiz() {
    this.showLoading()

    console.log('Starting quiz with ID:', this.quizId)
    const csrfToken = document.querySelector('[name="csrf-token"]')?.content
    console.log('CSRF Token found:', !!csrfToken)

    fetch(`/quiz_games/${this.quizId}/start`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      }
          })
    .then(response => {
      console.log('Response status:', response.status)
      console.log('Response OK:', response.ok)
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      console.log('Response data:', data)
      if (data.success) {
        this.userQuizGameId = data.user_quiz_game_id
        this.questions = data.questions
        this.quizInfo = data.quiz_info

        this.totalQuestionsTarget.textContent = this.questions.length
        this.hideLoading()
        this.showGameScreen()
        this.loadQuestion(0)
      } else {
        console.error('Erreur lors du démarrage:', data.error)
        alert('Erreur lors du démarrage du quiz')
        this.hideLoading()
      }
    })
    .catch(error => {
      console.error('Erreur:', error)
      alert('Erreur de connexion')
      this.hideLoading()
    })
  }

  loadQuestion(index) {
    if (index >= this.questions.length) {
      this.completeQuiz()
      return
    }

    this.currentQuestionIndex = index
    this.isAnswered = false
    const question = this.questions[index]

    // Mettre à jour l'interface
    this.currentQuestionTarget.textContent = index + 1
    this.questionImageTarget.src = question.image_url || '/assets/logo.png'
    this.questionTextTarget.textContent = question.content

    // Mettre à jour la barre de progression
    const progress = ((index) / this.questions.length) * 100
    this.progressBarTarget.style.width = `${progress}%`

    // Créer les boutons de réponse
    this.createAnswerButtons(question.answers)

    // Démarrer le timer
    this.startTimer()
  }

  createAnswerButtons(answers) {
    this.answersGridTarget.innerHTML = ''

    answers.forEach(answer => {
      const button = document.createElement('button')
      button.className = 'answer-option'
      button.textContent = answer.content
      button.dataset.answerId = answer.id
      button.addEventListener('click', () => this.selectAnswer(answer.id, button))

      this.answersGridTarget.appendChild(button)
    })
  }

  selectAnswer(answerId, buttonElement) {
    if (this.isAnswered) return

    this.isAnswered = true
    this.clearTimer()

    // Marquer la réponse sélectionnée
    buttonElement.classList.add('selected')

    // Désactiver tous les boutons
    const allButtons = this.answersGridTarget.querySelectorAll('.answer-option')
    allButtons.forEach(btn => btn.classList.add('disabled'))

    // Envoyer la réponse au serveur
    this.submitAnswer(answerId)
  }

  submitAnswer(answerId) {
    const question = this.questions[this.currentQuestionIndex]

    fetch(`/quiz_games/${this.quizId}/answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user_quiz_game_id: this.userQuizGameId,
        question_id: question.id,
        answer_id: answerId
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.handleAnswerResponse(data)
      } else {
        console.error('Erreur:', data.error)
        alert('Erreur lors de la soumission de la réponse')
      }
    })
    .catch(error => {
      console.error('Erreur:', error)
      alert('Erreur de connexion')
    })
  }

  handleAnswerResponse(data) {
    // Mettre à jour le score
    this.score = data.current_score
    this.currentScoreTarget.textContent = this.score

    // Colorer les boutons selon les réponses
    const allButtons = this.answersGridTarget.querySelectorAll('.answer-option')
    allButtons.forEach(button => {
      const answerId = parseInt(button.dataset.answerId)
      const question = this.questions[this.currentQuestionIndex]
      const answer = question.answers.find(a => a.id === answerId)

      if (button.classList.contains('selected')) {
        // Bouton sélectionné
        if (data.correct) {
          button.classList.add('correct')
        } else {
          button.classList.add('incorrect')
        }
      } else {
        // Montrer la bonne réponse
        if (answer && data.correct_answer === answer.content) {
          button.classList.add('correct')
        }
      }
    })

    // Afficher le feedback
    this.showFeedback(data)

    // Passer à la question suivante après 3 secondes
    setTimeout(() => {
      this.hideFeedback()
      this.loadQuestion(this.currentQuestionIndex + 1)
    }, 3000)
  }

  showFeedback(data) {
    const isCorrect = data.correct

    // Icône et couleur
    this.feedbackIconTarget.innerHTML = isCorrect
      ? '<i class="fas fa-check"></i>'
      : '<i class="fas fa-times"></i>'
    this.feedbackIconTarget.className = `feedback-icon ${isCorrect ? 'correct' : 'incorrect'}`

    // Titre
    this.feedbackTitleTarget.textContent = isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse'
    this.feedbackTitleTarget.className = `feedback-title ${isCorrect ? 'correct' : 'incorrect'}`

    // Texte explicatif
    this.feedbackTextTarget.textContent = isCorrect
      ? data.explanation
      : `La bonne réponse était : ${data.correct_answer}`

    // Points gagnés
    if (isCorrect && data.points_earned > 0) {
      this.feedbackPointsTarget.textContent = `+${data.points_earned} points !`
      this.feedbackPointsTarget.style.display = 'block'
    } else {
      this.feedbackPointsTarget.style.display = 'none'
    }

    // Afficher le modal
    this.feedbackModalTarget.style.display = 'flex'
  }

  hideFeedback() {
    this.feedbackModalTarget.style.display = 'none'
  }

  completeQuiz() {
    fetch(`/quiz_games/${this.quizId}/complete`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user_quiz_game_id: this.userQuizGameId
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.showResults(data)
      } else {
        console.error('Erreur:', data.error)
        alert('Erreur lors de la finalisation du quiz')
      }
    })
    .catch(error => {
      console.error('Erreur:', error)
      alert('Erreur de connexion')
    })
  }

  showResults(data) {
    // Masquer l'écran de jeu
    this.gameScreenTarget.style.display = 'none'

    // Remplir les statistiques
    this.finalScoreTarget.textContent = data.final_score
    this.correctAnswersTarget.textContent = data.correct_answers
    this.totalAnsweredTarget.textContent = data.total_questions

    // Afficher notification de level up si applicable
    if (data.level_up) {
      this.newLevelTarget.textContent = data.new_level
      this.levelUpNotificationTarget.style.display = 'block'
    }

    // Afficher l'écran de résultats
    this.resultsScreenTarget.style.display = 'block'
  }

  startTimer() {
    this.timeLeft = 24
    this.updateTimerDisplay()

    this.timer = setInterval(() => {
      this.timeLeft--
      this.updateTimerDisplay()

      if (this.timeLeft <= 0) {
        this.timeUp()
      }
    }, 1000)
  }

  updateTimerDisplay() {
    this.timerTextTarget.textContent = this.timeLeft

    // Changer la couleur selon le temps restant
    const timerCircle = this.timerTextTarget.parentElement
    timerCircle.classList.remove('warning', 'danger')

    if (this.timeLeft <= 5) {
      timerCircle.classList.add('danger')
    } else if (this.timeLeft <= 10) {
      timerCircle.classList.add('warning')
    }
  }

  timeUp() {
    if (this.isAnswered) return

    this.isAnswered = true
    this.clearTimer()

    // Désactiver tous les boutons
    const allButtons = this.answersGridTarget.querySelectorAll('.answer-option')
    allButtons.forEach(btn => btn.classList.add('disabled'))

    // Montrer la bonne réponse
    const question = this.questions[this.currentQuestionIndex]
    const correctAnswer = question.answers.find(a =>
      question.answers.find(answer => answer.content === question.correct_answer)
    )

    // Simuler une réponse incorrecte (temps écoulé)
    this.showFeedback({
      correct: false,
      points_earned: 0,
      correct_answer: question.answers.find(a => a.correct)?.content || "Réponse non trouvée",
      explanation: "Temps écoulé !"
    })

    // Passer à la question suivante après 3 secondes
    setTimeout(() => {
      this.hideFeedback()
      this.loadQuestion(this.currentQuestionIndex + 1)
    }, 3000)
  }

  clearTimer() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  showGameScreen() {
    this.startScreenTarget.style.display = 'none'
    this.gameScreenTarget.style.display = 'block'

    // Scroll vers le haut pour centrer la vue sur le jeu
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  showLoading() {
    this.startScreenTarget.style.display = 'none'
    this.loadingScreenTarget.style.display = 'block'
  }

  hideLoading() {
    this.loadingScreenTarget.style.display = 'none'
  }

  closeGame() {
    if (confirm('Êtes-vous sûr de vouloir quitter le quiz ? Votre progression sera perdue.')) {
      this.clearTimer()
      this.gameScreenTarget.style.display = 'none'
      this.startScreenTarget.style.display = 'block'

      // Reset des variables
      this.currentQuestionIndex = 0
      this.score = 0
      this.isAnswered = false
    }
  }
}
