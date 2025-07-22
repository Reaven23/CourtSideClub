

# Nettoyage des données existantes
puts "🧹 Nettoyage des données existantes..."
Player.destroy_all
Level.destroy_all
VoteCampaign.destroy_all

# Création des niveaux
puts "🏆 Création des niveaux..."
base_points = 50
multiplier = 1.2

# Niveau 1 : 0 points
Level.create!(number: 1, points: 0)

# Niveaux 2 à 100 avec progression exponentielle
(2..100).each do |level_number|
  points = (base_points * (multiplier ** (level_number - 2))).round
  Level.create!(number: level_number, points: points)
  puts "Niveau #{level_number}: #{points} points" if level_number <= 10 || level_number % 10 == 0
end

puts "✅ #{Level.count} niveaux créés!"

# Création des joueurs
puts "🏀 Création des joueurs..."
players_data = [
  { first_name: "Valentin", last_name: "Chery", tournament_played: 15, photo: "chery.png" },
  { first_name: "Kevin", last_name: "Thalien", tournament_played: 12, photo: "thalien.webp" },
  { first_name: "Fabien", last_name: "Bondron", tournament_played: 14, photo: "bondron.jpg" },
  { first_name: "Aya", last_name: "Jallier", tournament_played: 8, photo: "jallier.png" },
]

players_data.each do |player_data|
  player = Player.create!(
    first_name: player_data[:first_name],
    last_name: player_data[:last_name],
    tournament_played: player_data[:tournament_played]
  )

  # Attacher la photo si elle existe
  photo_path = Rails.root.join('app', 'assets', 'images', 'players', player_data[:photo])
  if File.exist?(photo_path)
    content_type = case File.extname(player_data[:photo]).downcase
                   when '.jpg', '.jpeg' then 'image/jpeg'
                   when '.png' then 'image/png'
                   when '.webp' then 'image/webp'
                   else 'image/jpeg'
                   end

    player.photo.attach(
      io: File.open(photo_path),
      filename: player_data[:photo],
      content_type: content_type
    )
    puts "✅ #{player.full_name} créé avec photo"
  else
    puts "⚠️  Photo non trouvée pour #{player.full_name}: #{player_data[:photo]}"
  end
end

puts "🎯 #{Level.count} niveaux créés (1-100)!"
puts "🎯 #{Player.count} joueurs créés au total!"
puts "🏀 Données de test prêtes pour les votes MVP!"

# Création de la campagne "Vote pour l'Open de France"
puts "🗳️ Création de la campagne de vote..."

open_france_campaign = VoteCampaign.create!(
  title: "Vote pour l'Open de France",
  description: "Parmi tous les joueurs CourtSideClub qui ont joué pour nous cette saison, seulement 4 pourront participer à l'Open de France et tenter de ramener le titre de champion de France. Prenez les choses en main et votez pour votre MVP. Il gagnera sa place dans le roster de l'Open. À vos votes !",
  start_date: Time.current,
  end_date: 2.weeks.from_now,
  active: true
)

# Ajouter tous les joueurs CourtSideClub à la campagne
Player.all.each do |player|
  open_france_campaign.vote_campaign_players.create!(player: player)
end

puts "✅ Campagne créée: #{open_france_campaign.title}"
puts "📅 Du #{open_france_campaign.start_date.strftime('%d/%m/%Y')} au #{open_france_campaign.end_date.strftime('%d/%m/%Y')}"
puts "🏀 #{open_france_campaign.players.count} joueurs disponibles:"
open_france_campaign.players.each { |p| puts "   - #{p.full_name} (#{p.tournament_played} tournois)" }
