

# Nettoyage des données existantes
# puts "🧹 Nettoyage des données existantes..."
# Player.destroy_all
# Level.destroy_all


# Création des niveaux
# puts "🏆 Création des niveaux..."
# base_points = 50
# multiplier = 1.2

# # Niveau 1 : 0 points
# Level.create!(number: 1, points: 0)

# # Niveaux 2 à 100 avec progression exponentielle
# (2..100).each do |level_number|
#   points = (base_points * (multiplier ** (level_number - 2))).round
#   Level.create!(number: level_number, points: points)
#   puts "Niveau #{level_number}: #{points} points" if level_number <= 10 || level_number % 10 == 0
# end

# puts "✅ #{Level.count} niveaux créés!"

# Vérification des joueurs existants
puts "🏀 Vérification des joueurs existants..."
puts "🎯 #{Player.count} joueurs disponibles dans la base de données"

# Création de la campagne de vote pour le Lite Quest de Versailles
puts "\n🗳️ Création de la campagne de vote pour le Lite Quest de Versailles..."

# D'abord, récupérer tous les joueurs
players = Player.all
puts "🏀 #{players.count} joueurs disponibles:"

# Créer la campagne de vote en utilisant skip_validation temporairement
lite_quest_campaign = VoteCampaign.new(
  title: "Sélection pour le Lite Quest de Versailles",
  description: "Votez pour le joueur qui sera obligatoirement sélectionné dans l'équipe pour participer au Lite Quest de Versailles du 30/08/2025. Parmi tous les joueurs CourtSideClub, choisissez celui qui mérite le plus de représenter notre équipe lors de cet événement prestigieux. À vos votes !",
  start_date: Date.new(2025, 6, 1),
  end_date: Date.new(2025, 7, 1),
  active: true
)

# Sauvegarder sans validation
lite_quest_campaign.save!(validate: false)

# Ajouter tous les joueurs CourtSideClub à la campagne
players.each do |player|
  lite_quest_campaign.vote_campaign_players.create!(player: player)
end

puts "✅ Campagne créée: #{lite_quest_campaign.title}"
puts "📅 Du #{lite_quest_campaign.start_date.strftime('%d/%m/%Y')} au #{lite_quest_campaign.end_date.strftime('%d/%m/%Y')}"
puts "🏀 #{lite_quest_campaign.players.count} joueurs disponibles:"
lite_quest_campaign.players.each { |p| puts "   - #{p.full_name} (#{p.tournament_played} tournois)" }

# Création de la campagne "Vote pour l'Open de France"
# puts "🗳️ Création de la campagne de vote..."

# open_france_campaign = VoteCampaign.create!(
#   title: "Vote pour l'Open de France",
#   description: "Parmi tous les joueurs CourtSideClub qui ont joué pour nous cette saison, seulement 4 pourront participer à l'Open de France et tenter de ramener le titre de champion de France. Prenez les choses en main et votez pour votre MVP. Il gagnera sa place dans le roster de l'Open. À vos votes !",
#   start_date: Time.current,
#   end_date: 2.weeks.from_now,
#   active: true
# )

# puts "🏀 #{Player.count} joueurs disponibles:"

# # Ajouter tous les joueurs CourtSideClub à la campagne
# Player.all.each do |player|
#   open_france_campaign.vote_campaign_players.create!(player: player)
# end

# puts "✅ Campagne créée: #{open_france_campaign.title}"
# puts "📅 Du #{open_france_campaign.start_date.strftime('%d/%m/%Y')} au #{open_france_campaign.end_date.strftime('%d/%m/%Y')}"
# puts "🏀 #{open_france_campaign.players.count} joueurs disponibles:"
# open_france_campaign.players.each { |p| puts "   - #{p.full_name} (#{p.tournament_played} tournois)" }

# puts "\n🗳️ Création de la deuxième campagne de vote..."

# interview_campaign = VoteCampaign.create!(
#   title: "Interview du mois d'Août",
#   description: "Comme tous les mois, vous pouvez choisir le joueur de notre CourtSideClub squad que vous souhaitez avoir en interview. À vos votes et n'hésitez pas à nous laisser en commentaire les des questions que vous voudriez poser!",
#   start_date: Date.new(2025, 7, 1),
#   end_date: 1.week.from_now,
#   active: true
# )

# # Ajouter tous les joueurs CourtSideClub à la campagne interview
# Player.all.each do |player|
#   interview_campaign.vote_campaign_players.create!(player: player)
# end

# puts "✅ Campagne créée: #{interview_campaign.title}"
# puts "📅 Du #{interview_campaign.start_date.strftime('%d/%m/%Y')} au #{interview_campaign.end_date.strftime('%d/%m/%Y')}"
# puts "🏀 #{interview_campaign.players.count} joueurs disponibles:"
# interview_campaign.players.each { |p| puts "   - #{p.full_name} (#{p.tournament_played} tournois)" }

# # Création de la deuxième campagne "Interview du mois d'Août"
# puts "\n🗳️ Création de la troisième campagne de vote..."

# interview_campaign = VoteCampaign.create!(
#   title: "Interview du mois de Septembre",
#   description: "Comme tous les mois, vous pouvez choisir le joueur de notre CourtSideClub squad que vous souhaitez avoir en interview. À vos votes et n'hésitez pas à nous laisser en commentaire les des questions que vous voudriez poser!",
#   start_date: 1.week.from_now,
#   end_date: 3.weeks.from_now,
#   active: true
# )

# # Ajouter tous les joueurs CourtSideClub à la campagne interview
# Player.all.each do |player|
#   interview_campaign.vote_campaign_players.create!(player: player)
# end

# puts "✅ Campagne créée: #{interview_campaign.title}"
# puts "📅 Du #{interview_campaign.start_date.strftime('%d/%m/%Y')} au #{interview_campaign.end_date.strftime('%d/%m/%Y')}"
# puts "🏀 #{interview_campaign.players.count} joueurs disponibles:"
# interview_campaign.players.each { |p| puts "   - #{p.full_name} (#{p.tournament_played} tournois)" }

# Chargement des QuizGames depuis le fichier séparé
# puts "\n" + "="*50
# puts "🎮 CHARGEMENT DES QUIZGAMES..."
# puts "="*50
# load Rails.root.join('db', 'seeds_quiz_games.rb')

# Génération de 150 utilisateurs multi-ethniques
# puts "\n" + "="*50
# puts "👥 GÉNÉRATION DE 150 UTILISATEURS..."
# puts "="*50

# # Nettoyage des utilisateurs existants (sauf admin)

# # Données multi-ethniques pour les noms et prénoms
# first_names = {
#   # Prénoms français
#   french: ["Alexandre", "Camille", "Lucas", "Emma", "Hugo", "Léa", "Thomas", "Chloé", "Nathan", "Manon", "Antoine", "Sarah", "Maxime", "Julie", "Romain", "Laura", "Julien", "Marine", "Baptiste", "Pauline", "Nicolas", "Claire", "Pierre", "Céline", "Sébastien", "Audrey", "Vincent", "Nathalie", "Guillaume", "Sophie", "Cédric", "Isabelle", "David", "Valérie", "Fabien", "Sandrine", "Jérémy", "Catherine", "Florian", "Patricia"],

#   # Prénoms africains
#   african: ["Aïcha", "Moussa", "Fatou", "Ibrahim", "Aminata", "Ousmane", "Kadiatou", "Mamadou", "Mariama", "Sékou", "Aissatou", "Boubacar", "Nafissatou", "Cheikh", "Aïssata", "Modou", "Ramatou", "Moussa", "Aïda", "Amadou", "Kadidia", "Bakary", "Aïssa", "Mamadou", "Fatima", "Ibrahima", "Aïcha", "Souleymane", "Mariam", "Abdoulaye", "Aminata", "Moussa", "Kadiatou", "Cheikh", "Aïssatou", "Boubacar", "Mariama", "Ousmane", "Aïda", "Amadou"],

#   # Prénoms arabes
#   arabic: ["Ahmed", "Fatima", "Mohamed", "Aïcha", "Omar", "Khadija", "Hassan", "Zainab", "Ali", "Mariam", "Youssef", "Amina", "Ibrahim", "Hafsa", "Khalid", "Safiya", "Tariq", "Layla", "Rachid", "Nour", "Said", "Yasmina", "Karim", "Salma", "Nabil", "Dounia", "Fouad", "Hiba", "Walid", "Rania", "Adel", "Nadia", "Tarek", "Samira", "Hicham", "Farida", "Reda", "Malika", "Yassine", "Khadija"],

#   # Prénoms asiatiques
#   asian: ["Wei", "Li", "Chen", "Wang", "Zhang", "Liu", "Yang", "Huang", "Zhao", "Wu", "Zhou", "Xu", "Sun", "Ma", "Zhu", "Hu", "Guo", "He", "Gao", "Lin", "Luo", "Zeng", "Peng", "Lu", "Jiang", "Cai", "Deng", "Xie", "Tang", "Shen", "Han", "Xiao", "Feng", "Zeng", "Cao", "Fang", "Cheng", "Ding", "Ren", "Yao"],

#   # Prénoms hispaniques
#   hispanic: ["Carlos", "Maria", "Jose", "Ana", "Luis", "Carmen", "Antonio", "Isabel", "Francisco", "Rosa", "Manuel", "Pilar", "David", "Teresa", "Daniel", "Cristina", "Miguel", "Dolores", "Rafael", "Mercedes", "Javier", "Josefa", "Fernando", "Francisca", "Angel", "Antonia", "Alejandro", "Dolores", "Ramon", "Pilar", "Sergio", "Concepcion", "Alberto", "Rosario", "Roberto", "Encarnacion", "Eduardo", "Esperanza", "Victor", "Soledad"],

#   # Prénoms anglo-saxons
#   anglo_saxon: ["James", "Mary", "John", "Patricia", "Robert", "Jennifer", "Michael", "Linda", "William", "Elizabeth", "David", "Barbara", "Richard", "Susan", "Joseph", "Jessica", "Thomas", "Sarah", "Christopher", "Karen", "Charles", "Nancy", "Daniel", "Lisa", "Matthew", "Betty", "Anthony", "Helen", "Mark", "Sandra", "Donald", "Donna", "Steven", "Carol", "Paul", "Ruth", "Andrew", "Sharon", "Joshua", "Michelle"],

#   # Prénoms slaves
#   slavic: ["Ivan", "Anna", "Sergey", "Elena", "Dmitri", "Olga", "Vladimir", "Tatiana", "Alexei", "Natalia", "Andrei", "Svetlana", "Mikhail", "Irina", "Nikolai", "Ludmila", "Pavel", "Galina", "Roman", "Valentina", "Oleg", "Nina", "Viktor", "Raisa", "Yuri", "Vera", "Anatoly", "Lyudmila", "Boris", "Tamara", "Gennady", "Zinaida", "Vladislav", "Larisa", "Stanislav", "Nadezhda", "Vyacheslav", "Valentina", "Grigory", "Raisa"]
# }

# last_names = {
#   # Noms français
#   french: ["Martin", "Bernard", "Thomas", "Petit", "Robert", "Richard", "Durand", "Dubois", "Moreau", "Laurent", "Simon", "Michel", "Lefebvre", "Leroy", "Roux", "David", "Bertrand", "Morel", "Fournier", "Girard", "Bonnet", "Dupont", "Lambert", "Fontaine", "Rousseau", "Vincent", "Muller", "Lefevre", "Faure", "Andre", "Mercier", "Blanc", "Guerin", "Boyer", "Garnier", "Chevalier", "Francois", "Legrand", "Gauthier", "Garcia"],

#   # Noms africains
#   african: ["Traore", "Diallo", "Sangare", "Coulibaly", "Keita", "Kone", "Diop", "Ba", "Ndiaye", "Fall", "Diagne", "Sarr", "Thiam", "Gueye", "Faye", "Diouf", "Niang", "Sy", "Camara", "Sow", "Mane", "Dia", "Beye", "Ndao", "Diatta", "Sene", "Diouf", "Mbaye", "Seck", "Ndiaye", "Diagne", "Sarr", "Fall", "Ba", "Diop", "Kone", "Keita", "Coulibaly", "Sangare", "Diallo"],

#   # Noms arabes
#   arabic: ["Alami", "Benali", "Cherif", "Hassani", "Idrissi", "Kabbaj", "Lahlou", "Mansouri", "Naciri", "Ouali", "Rahmani", "Saadi", "Tazi", "Zerouali", "Ait", "Bennani", "Chraibi", "Dahmani", "El", "Fassi", "Gharbi", "Hajji", "Iraqi", "Jabri", "Khattabi", "Lahlou", "Mansouri", "Naciri", "Ouali", "Rahmani", "Saadi", "Tazi", "Zerouali", "Ait", "Bennani", "Chraibi", "Dahmani", "El", "Fassi", "Gharbi"],

#   # Noms asiatiques
#   asian: ["Wang", "Li", "Zhang", "Liu", "Chen", "Yang", "Huang", "Zhao", "Wu", "Zhou", "Xu", "Sun", "Ma", "Zhu", "Hu", "Guo", "He", "Gao", "Lin", "Luo", "Zeng", "Peng", "Lu", "Jiang", "Cai", "Deng", "Xie", "Tang", "Shen", "Han", "Xiao", "Feng", "Zeng", "Cao", "Fang", "Cheng", "Ding", "Ren", "Yao", "Liang"],

#   # Noms hispaniques
#   hispanic: ["Garcia", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Perez", "Sanchez", "Ramirez", "Cruz", "Flores", "Gomez", "Diaz", "Reyes", "Morales", "Jimenez", "Ruiz", "Torres", "Vargas", "Ramos", "Mendoza", "Castillo", "Moreno", "Herrera", "Medina", "Aguilar", "Rivera", "Silva", "Vega", "Rojas", "Espinoza", "Castro", "Romero", "Alvarez", "Mendez", "Gutierrez", "Ortiz", "Chavez", "Ramos", "Mendoza"],

#   # Noms anglo-saxons
#   anglo_saxon: ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores"],

#   # Noms slaves
#   slavic: ["Ivanov", "Petrov", "Sidorov", "Kozlov", "Morozov", "Volkov", "Alekseev", "Lebedev", "Semenov", "Egorov", "Pavlov", "Kozlov", "Stepanov", "Nikolaev", "Orlov", "Andreev", "Makarov", "Nikitin", "Zakharov", "Zaitsev", "Popov", "Sokolov", "Lebedev", "Kozlov", "Novikov", "Morozov", "Petrov", "Volkov", "Sokolov", "Kozlov", "Lebedev", "Morozov", "Petrov", "Volkov", "Sokolov", "Kozlov", "Lebedev", "Morozov", "Petrov", "Volkov"]
# }

# # Domaines email variés
# email_domains = [
#   "gmail.com", "yahoo.com", "hotmail.com", "outlook.com", "live.com",
#   "icloud.com", "protonmail.com", "yandex.com", "mail.com", "zoho.com",
#   "aol.com", "msn.com", "orange.fr", "free.fr", "wanadoo.fr",
#   "laposte.net", "sfr.fr", "bouyguestelecom.fr", "numericable.fr", "aliceadsl.fr"
# ]

# # Génération des utilisateurs
# puts "👤 Création de 150 utilisateurs..."

# 150.times do |i|
#   # Sélection aléatoire d'une origine ethnique
#   ethnicities = first_names.keys
#   selected_ethnicity = ethnicities.sample

#   # Sélection aléatoire des noms
#   first_name = first_names[selected_ethnicity].sample
#   last_name = last_names[selected_ethnicity].sample

#   # Génération de l'email
#   email_prefix = "#{first_name.downcase}.#{last_name.downcase}#{rand(1..999)}"
#   email_domain = email_domains.sample
#   email = "#{email_prefix}@#{email_domain}"

#   # Génération de la date de naissance (13-65 ans)
#   age = rand(14..65)
#   birthdate = (age.years.ago + rand(0..365).days).to_date

#   # Génération des points (0-5000)
#   points = rand(0..5000)

#   # Création de l'utilisateur
#   user = User.create!(
#     first_name: first_name,
#     last_name: last_name,
#     email: email,
#     password: "password123", # Mot de passe par défaut
#     password_confirmation: "password123",
#     birthdate: birthdate,
#     points: points,
#     admin: false
#   )

#   # Affichage du progrès
#   if (i + 1) % 25 == 0
#     puts "✅ #{i + 1}/150 utilisateurs créés..."
#   end
# end

# puts "🎉 #{User.count} utilisateurs créés au total!"
# puts "📊 Répartition par origine:"
# ethnicities = first_names.keys
# ethnicities.each do |ethnicity|
#   count = User.joins("LEFT JOIN levels ON users.level_id = levels.id")
#               .where("users.first_name IN (?)", first_names[ethnicity])
#               .count
#   puts "   - #{ethnicity.to_s.capitalize}: #{count} utilisateurs"
# end

# puts "🏆 Niveaux assignés automatiquement selon les points!"
# puts "📧 Emails générés avec des domaines variés!"
# puts "🎂 Âges compris entre 13 et 65 ans!"

# ── Shop Products ──
puts "\n🛒 Création des produits boutique..."

tshirt = Product.find_or_create_by!(name: "T-shirt CourtSideClub") do |p|
  p.price_cents = 2000
  p.product_type = "one_time"
  p.description = "T-shirt officiel CourtSideClub 3x3"
  p.active = true
end

%w[S M L XL XXL].each do |size|
  tshirt.product_variants.find_or_create_by!(size: size) do |v|
    v.stock = 50
  end
end

membership = Product.find_or_create_by!(name: "Adhésion annuelle CourtSideClub") do |p|
  p.price_cents = 4900
  p.product_type = "subscription"
  p.description = "Adhésion annuelle avec t-shirt offert"
  p.active = true
end

puts "✅ #{Product.count} produits créés"
puts "   - #{tshirt.name}: #{tshirt.price}€ (#{tshirt.product_variants.count} tailles)"
puts "   - #{membership.name}: #{membership.price}€/an"
