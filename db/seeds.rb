

puts "🎯 Création des niveaux de gamification..."

Level.destroy_all

base_points = 50
multiplier = 1.2

(1..100).each do |level_number|
  if level_number == 1
    points = 0  
  else
    points = (base_points * (multiplier ** (level_number - 2))).round
  end

  level = Level.create!(
    number: level_number,
    points: points
  )

  if level_number <= 10 || level_number % 10 == 0
    puts "✅ Niveau #{level_number}: #{level.name} (#{points} points)"
  end
end

puts "🏀 Création des joueurs de CourtSideClub..."

Player.destroy_all

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

  puts "✅ Joueur créé: #{player.full_name} (#{player.tournament_played} tournois)"

  # Attacher la photo si elle existe
  photo_path = Rails.root.join("app", "assets", "images", "players", player_data[:photo])
  if File.exist?(photo_path)
    # Déterminer le content_type basé sur l'extension
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
    puts "📸 Photo attachée pour #{player.full_name}: #{player_data[:photo]}"
  else
    puts "⚠️  Photo non trouvée pour #{player.full_name}: #{player_data[:photo]}"
  end
end

puts "🎯 #{Level.count} niveaux créés (1-100)!"
puts "🎯 #{Player.count} joueurs créés au total!"
puts "🏀 Données de test prêtes pour les votes MVP!"
