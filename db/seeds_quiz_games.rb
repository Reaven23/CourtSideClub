# # Seeds pour les QuizGames
# puts "🧹 Nettoyage des données QuizGames existantes..."
# QuizGame.destroy_all

# puts "🎮 Création des QuizGames..."

# # Quiz 1: Connaissances générales CourtSideClub
# quiz1 = QuizGame.create!(
#   title: "Connaissances CourtSideClub",
#   description: "Testez vos connaissances sur le club CourtSideClub ! Questions sur les joueurs, l'histoire du club et les performances.",
#   score: 100,
#   points: 25,
#   active: true
# )

# puts "✅ Quiz créé: #{quiz1.title}"

# # Questions pour le Quiz 1
# questions_data_1 = [
#   {
#     content: "Combien de tournois Valentin Chery a-t-il joués cette saison ?",
#     order: 1,
#     answers: [
#       { content: "12 tournois", correct: false, order: 1 },
#       { content: "15 tournois", correct: true, order: 2 },
#       { content: "18 tournois", correct: false, order: 3 },
#       { content: "10 tournois", correct: false, order: 4 }
#     ]
#   },
#   {
#     content: "Quel joueur a participé au moins de tournois cette saison ?",
#     order: 2,
#     answers: [
#       { content: "Kevin Thalien", correct: false, order: 1 },
#       { content: "Fabien Bondron", correct: false, order: 2 },
#       { content: "Aya Jallier", correct: true, order: 3 },
#       { content: "Valentin Chery", correct: false, order: 4 }
#     ]
#   },
#   {
#     content: "Combien de joueurs composent actuellement l'équipe CourtSideClub ?",
#     order: 3,
#     answers: [
#       { content: "3 joueurs", correct: false, order: 1 },
#       { content: "4 joueurs", correct: true, order: 2 },
#       { content: "5 joueurs", correct: false, order: 3 },
#       { content: "6 joueurs", correct: false, order: 4 }
#     ]
#   }
# ]

# questions_data_1.each do |q_data|
#   question = quiz1.questions.create!(
#     content: q_data[:content],
#     order: q_data[:order]
#   )

#   q_data[:answers].each do |a_data|
#     question.answers.create!(
#       content: a_data[:content],
#       correct: a_data[:correct],
#       order: a_data[:order]
#     )
#   end

#   puts "  ✅ Question #{q_data[:order]}: #{q_data[:content][0..50]}..."
# end

# # Quiz 2: Culture Basketball
# quiz2 = QuizGame.create!(
#   title: "Culture Basketball",
#   description: "Connaissez-vous bien l'univers du basketball ? Questions sur les règles, l'histoire et les légendes du basket.",
#   score: 150,
#   points: 40,
#   active: true
# )

# puts "✅ Quiz créé: #{quiz2.title}"

# # Questions pour le Quiz 2
# questions_data_2 = [
#   {
#     content: "Combien de joueurs composent une équipe sur le terrain en basketball ?",
#     order: 1,
#     answers: [
#       { content: "4 joueurs", correct: false, order: 1 },
#       { content: "5 joueurs", correct: true, order: 2 },
#       { content: "6 joueurs", correct: false, order: 3 },
#       { content: "7 joueurs", correct: false, order: 4 }
#     ]
#   },
#   {
#     content: "Quelle est la hauteur réglementaire d'un panier de basketball ?",
#     order: 2,
#     answers: [
#       { content: "2,95 mètres", correct: false, order: 1 },
#       { content: "3,05 mètres", correct: true, order: 2 },
#       { content: "3,15 mètres", correct: false, order: 3 },
#       { content: "3,25 mètres", correct: false, order: 4 }
#     ]
#   },
#   {
#     content: "En quelle année le basketball a-t-il été inventé ?",
#     order: 3,
#     answers: [
#       { content: "1885", correct: false, order: 1 },
#       { content: "1891", correct: true, order: 2 },
#       { content: "1895", correct: false, order: 3 },
#       { content: "1901", correct: false, order: 4 }
#     ]
#   },
#   {
#     content: "Combien de points vaut un panier à 3 points ?",
#     order: 4,
#     answers: [
#       { content: "2 points", correct: false, order: 1 },
#       { content: "3 points", correct: true, order: 2 },
#       { content: "4 points", correct: false, order: 3 },
#       { content: "5 points", correct: false, order: 4 }
#     ]
#   }
# ]

# questions_data_2.each do |q_data|
#   question = quiz2.questions.create!(
#     content: q_data[:content],
#     order: q_data[:order]
#   )

#   q_data[:answers].each do |a_data|
#     question.answers.create!(
#       content: a_data[:content],
#       correct: a_data[:correct],
#       order: a_data[:order]
#     )
#   end

#   puts "  ✅ Question #{q_data[:order]}: #{q_data[:content][0..50]}..."
# end

# # Quiz 3: Quiz défi (plus difficile)
# quiz3 = QuizGame.create!(
#   title: "Défi CourtSideClub Expert",
#   description: "Le quiz ultime pour les vrais experts ! Questions pointues sur le basketball et le club. Êtes-vous prêt pour le défi ?",
#   score: 200,
#   points: 75,
#   active: true
# )

# puts "✅ Quiz créé: #{quiz3.title}"

# # Questions pour le Quiz 3 (plus difficiles)
# questions_data_3 = [
#   {
#     content: "Quelle est la durée d'un match de basketball professionnel (4 quart-temps) ?",
#     order: 1,
#     answers: [
#       { content: "40 minutes", correct: false, order: 1 },
#       { content: "48 minutes", correct: true, order: 2 },
#       { content: "50 minutes", correct: false, order: 3 },
#       { content: "45 minutes", correct: false, order: 4 }
#     ]
#   },
#   {
#     content: "Quel est le nombre total de tournois joués par tous les joueurs CourtSideClub cette saison ?",
#     order: 2,
#     answers: [
#       { content: "47 tournois", correct: false, order: 1 },
#       { content: "49 tournois", correct: true, order: 2 },
#       { content: "51 tournois", correct: false, order: 3 },
#       { content: "53 tournois", correct: false, order: 4 }
#     ]
#   }
# ]

# questions_data_3.each do |q_data|
#   question = quiz3.questions.create!(
#     content: q_data[:content],
#     order: q_data[:order]
#   )

#   q_data[:answers].each do |a_data|
#     question.answers.create!(
#       content: a_data[:content],
#       correct: a_data[:correct],
#       order: a_data[:order]
#     )
#   end

#   puts "  ✅ Question #{q_data[:order]}: #{q_data[:content][0..50]}..."
# end

# puts "\n🎯 Récapitulatif QuizGames:"
# puts "📊 #{QuizGame.count} quiz créés"
# puts "❓ #{Question.count} questions au total"
# puts "💡 #{Answer.count} réponses au total"

# QuizGame.all.each do |quiz|
#   correct_answers = quiz.questions.joins(:answers).where(answers: { correct: true }).count
#   puts "  🎮 #{quiz.title}: #{quiz.questions.count} questions, #{correct_answers} bonnes réponses (#{quiz.points} points max)"
# end

# puts "\n✅ Seeds QuizGames terminés avec succès !"

# Seeds pour le Quiz CourtSideClub
puts "🎯 Création du quiz CourtSideClub..."

# Créer le quiz principal
quiz = QuizGame.find_or_create_by(title: "CourtSideClub - Quiz Général") do |q|
  q.description = "Testez vos connaissances sur la plateforme CourtSideClub et le basket en général"
  q.points_per_question = 10
  q.active = true
end

puts "✅ Quiz créé : #{quiz.title}"

# Questions et réponses
questions_data = [
  {
    content: "Qu'est-ce que CourtSideClub ?",
    order: 1,
    answers: [
      { content: "Une plateforme de streaming sportif", correct: false, order: 1 },
      { content: "Une communauté de fans de basket avec système de points et récompenses", correct: true, order: 2 },
      { content: "Un club de basket professionnel", correct: false, order: 3 },
      { content: "Une application de paris sportifs", correct: false, order: 4 }
    ]
  },
  {
    content: "Comment gagner des points sur CourtSideClub ?",
    order: 2,
    answers: [
      { content: "En regardant des matchs", correct: false, order: 1 },
      { content: "En votant pour vos joueurs favoris et en participant aux activités", correct: true, order: 2 },
      { content: "En achetant des produits", correct: false, order: 3 },
      { content: "En partageant sur les réseaux sociaux", correct: false, order: 4 }
    ]
  },
  {
    content: "Quel est le système de niveaux sur CourtSideClub ?",
    order: 3,
    answers: [
      { content: "Basé sur le temps passé sur la plateforme", correct: false, order: 1 },
      { content: "Basé sur le nombre de points accumulés", correct: true, order: 2 },
      { content: "Basé sur le nombre d'amis", correct: false, order: 3 },
      { content: "Basé sur l'âge de l'utilisateur", correct: false, order: 4 }
    ]
  },
  {
    content: "Que peut-on faire avec les points CourtSideClub ?",
    order: 4,
    answers: [
      { content: "Les échanger contre de l'argent", correct: false, order: 1 },
      { content: "Débloquer des récompenses exclusives et des avantages", correct: true, order: 2 },
      { content: "Acheter des équipements de basket", correct: false, order: 3 },
      { content: "Les transférer à d'autres utilisateurs", correct: false, order: 4 }
    ]
  },
  {
    content: "Qu'est-ce qu'une campagne de vote sur CourtSideClub ?",
    order: 5,
    answers: [
      { content: "Une élection politique", correct: false, order: 1 },
      { content: "Une période où les utilisateurs peuvent voter pour leurs joueurs favoris", correct: true, order: 2 },
      { content: "Une campagne publicitaire", correct: false, order: 3 },
      { content: "Un tournoi de basket", correct: false, order: 4 }
    ]
  },
  {
    content: "Combien de points gagne-t-on généralement par vote ?",
    order: 6,
    answers: [
      { content: "1 point", correct: false, order: 1 },
      { content: "5 points", correct: true, order: 2 },
      { content: "10 points", correct: false, order: 3 },
      { content: "20 points", correct: false, order: 4 }
    ]
  },
  {
    content: "Que signifie 'ROI Mesurable' dans le contexte des partenaires CourtSideClub ?",
    order: 7,
    answers: [
      { content: "Retour sur investissement mesurable grâce aux données d'engagement", correct: true, order: 1 },
      { content: "Règlement des obligations internationales", correct: false, order: 2 },
      { content: "Réseau d'organisations internationales", correct: false, order: 3 },
      { content: "Rapport d'opérations internes", correct: false, order: 4 }
    ]
  },
  {
    content: "Quel est l'avantage principal pour les partenaires sur CourtSideClub ?",
    order: 8,
    answers: [
      { content: "Vendre des produits directement", correct: false, order: 1 },
      { content: "Augmenter leur visibilité et engagement avec une communauté active", correct: true, order: 2 },
      { content: "Recevoir des subventions", correct: false, order: 3 },
      { content: "Accéder à des données personnelles", correct: false, order: 4 }
    ]
  },
  {
    content: "Comment fonctionne le système de récompenses CourtSideClub ?",
    order: 9,
    answers: [
      { content: "Les récompenses sont automatiquement attribuées", correct: false, order: 1 },
      { content: "Les utilisateurs peuvent échanger leurs points contre des récompenses", correct: true, order: 2 },
      { content: "Les récompenses sont tirées au sort", correct: false, order: 3 },
      { content: "Les récompenses sont payantes", correct: false, order: 4 }
    ]
  },
  {
    content: "Quelle est la mission principale de CourtSideClub ?",
    order: 10,
    answers: [
      { content: "Organiser des tournois de basket", correct: false, order: 1 },
      { content: "Donner le pouvoir aux fans de basket et créer une communauté engagée", correct: true, order: 2 },
      { content: "Vendre des équipements de sport", correct: false, order: 3 },
      { content: "Diffuser des matchs en direct", correct: false, order: 4 }
    ]
  }
]

# Créer les questions et réponses
questions_data.each do |question_data|
  puts "📝 Création de la question #{question_data[:order]}..."

  question = quiz.questions.find_or_create_by(order: question_data[:order]) do |q|
    q.content = question_data[:content]
  end

  # Créer les réponses pour cette question
  question_data[:answers].each do |answer_data|
    question.answers.find_or_create_by(order: answer_data[:order]) do |a|
      a.content = answer_data[:content]
      a.correct = answer_data[:correct]
    end
  end

  puts "✅ Question créée : #{question.content[0..50]}..."
end

puts "�� Quiz CourtSideClub créé avec succès !"
puts "📊 #{quiz.questions.count} questions créées"
puts "�� #{quiz.questions.joins(:answers).where(answers: { correct: true }).count} bonnes réponses définies"
