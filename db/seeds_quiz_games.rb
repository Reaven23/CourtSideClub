# Seeds pour les QuizGames
puts "🧹 Nettoyage des données QuizGames existantes..."
QuizGame.destroy_all

puts "🎮 Création des QuizGames..."

# Quiz 1: Connaissances générales CourtSideClub
quiz1 = QuizGame.create!(
  title: "Connaissances CourtSideClub",
  description: "Testez vos connaissances sur le club CourtSideClub ! Questions sur les joueurs, l'histoire du club et les performances.",
  score: 100,
  points: 25,
  active: true
)

puts "✅ Quiz créé: #{quiz1.title}"

# Questions pour le Quiz 1
questions_data_1 = [
  {
    content: "Combien de tournois Valentin Chery a-t-il joués cette saison ?",
    order: 1,
    answers: [
      { content: "12 tournois", correct: false, order: 1 },
      { content: "15 tournois", correct: true, order: 2 },
      { content: "18 tournois", correct: false, order: 3 },
      { content: "10 tournois", correct: false, order: 4 }
    ]
  },
  {
    content: "Quel joueur a participé au moins de tournois cette saison ?",
    order: 2,
    answers: [
      { content: "Kevin Thalien", correct: false, order: 1 },
      { content: "Fabien Bondron", correct: false, order: 2 },
      { content: "Aya Jallier", correct: true, order: 3 },
      { content: "Valentin Chery", correct: false, order: 4 }
    ]
  },
  {
    content: "Combien de joueurs composent actuellement l'équipe CourtSideClub ?",
    order: 3,
    answers: [
      { content: "3 joueurs", correct: false, order: 1 },
      { content: "4 joueurs", correct: true, order: 2 },
      { content: "5 joueurs", correct: false, order: 3 },
      { content: "6 joueurs", correct: false, order: 4 }
    ]
  }
]

questions_data_1.each do |q_data|
  question = quiz1.questions.create!(
    content: q_data[:content],
    order: q_data[:order]
  )

  q_data[:answers].each do |a_data|
    question.answers.create!(
      content: a_data[:content],
      correct: a_data[:correct],
      order: a_data[:order]
    )
  end

  puts "  ✅ Question #{q_data[:order]}: #{q_data[:content][0..50]}..."
end

# Quiz 2: Culture Basketball
quiz2 = QuizGame.create!(
  title: "Culture Basketball",
  description: "Connaissez-vous bien l'univers du basketball ? Questions sur les règles, l'histoire et les légendes du basket.",
  score: 150,
  points: 40,
  active: true
)

puts "✅ Quiz créé: #{quiz2.title}"

# Questions pour le Quiz 2
questions_data_2 = [
  {
    content: "Combien de joueurs composent une équipe sur le terrain en basketball ?",
    order: 1,
    answers: [
      { content: "4 joueurs", correct: false, order: 1 },
      { content: "5 joueurs", correct: true, order: 2 },
      { content: "6 joueurs", correct: false, order: 3 },
      { content: "7 joueurs", correct: false, order: 4 }
    ]
  },
  {
    content: "Quelle est la hauteur réglementaire d'un panier de basketball ?",
    order: 2,
    answers: [
      { content: "2,95 mètres", correct: false, order: 1 },
      { content: "3,05 mètres", correct: true, order: 2 },
      { content: "3,15 mètres", correct: false, order: 3 },
      { content: "3,25 mètres", correct: false, order: 4 }
    ]
  },
  {
    content: "En quelle année le basketball a-t-il été inventé ?",
    order: 3,
    answers: [
      { content: "1885", correct: false, order: 1 },
      { content: "1891", correct: true, order: 2 },
      { content: "1895", correct: false, order: 3 },
      { content: "1901", correct: false, order: 4 }
    ]
  },
  {
    content: "Combien de points vaut un panier à 3 points ?",
    order: 4,
    answers: [
      { content: "2 points", correct: false, order: 1 },
      { content: "3 points", correct: true, order: 2 },
      { content: "4 points", correct: false, order: 3 },
      { content: "5 points", correct: false, order: 4 }
    ]
  }
]

questions_data_2.each do |q_data|
  question = quiz2.questions.create!(
    content: q_data[:content],
    order: q_data[:order]
  )

  q_data[:answers].each do |a_data|
    question.answers.create!(
      content: a_data[:content],
      correct: a_data[:correct],
      order: a_data[:order]
    )
  end

  puts "  ✅ Question #{q_data[:order]}: #{q_data[:content][0..50]}..."
end

# Quiz 3: Quiz défi (plus difficile)
quiz3 = QuizGame.create!(
  title: "Défi CourtSideClub Expert",
  description: "Le quiz ultime pour les vrais experts ! Questions pointues sur le basketball et le club. Êtes-vous prêt pour le défi ?",
  score: 200,
  points: 75,
  active: true
)

puts "✅ Quiz créé: #{quiz3.title}"

# Questions pour le Quiz 3 (plus difficiles)
questions_data_3 = [
  {
    content: "Quelle est la durée d'un match de basketball professionnel (4 quart-temps) ?",
    order: 1,
    answers: [
      { content: "40 minutes", correct: false, order: 1 },
      { content: "48 minutes", correct: true, order: 2 },
      { content: "50 minutes", correct: false, order: 3 },
      { content: "45 minutes", correct: false, order: 4 }
    ]
  },
  {
    content: "Quel est le nombre total de tournois joués par tous les joueurs CourtSideClub cette saison ?",
    order: 2,
    answers: [
      { content: "47 tournois", correct: false, order: 1 },
      { content: "49 tournois", correct: true, order: 2 },
      { content: "51 tournois", correct: false, order: 3 },
      { content: "53 tournois", correct: false, order: 4 }
    ]
  }
]

questions_data_3.each do |q_data|
  question = quiz3.questions.create!(
    content: q_data[:content],
    order: q_data[:order]
  )

  q_data[:answers].each do |a_data|
    question.answers.create!(
      content: a_data[:content],
      correct: a_data[:correct],
      order: a_data[:order]
    )
  end

  puts "  ✅ Question #{q_data[:order]}: #{q_data[:content][0..50]}..."
end

puts "\n🎯 Récapitulatif QuizGames:"
puts "📊 #{QuizGame.count} quiz créés"
puts "❓ #{Question.count} questions au total"
puts "💡 #{Answer.count} réponses au total"

QuizGame.all.each do |quiz|
  correct_answers = quiz.questions.joins(:answers).where(answers: { correct: true }).count
  puts "  🎮 #{quiz.title}: #{quiz.questions.count} questions, #{correct_answers} bonnes réponses (#{quiz.points} points max)"
end

puts "\n✅ Seeds QuizGames terminés avec succès !"
