# Script pour créer des votes de test en console Rails
# À exécuter avec: rails console
# Puis: load 'console_votes_script.rb'

puts "🗳️ Création de votes de test pour la campagne Lite Quest de Versailles..."

# Récupérer la campagne de vote
lite_quest_campaign = VoteCampaign.last

if lite_quest_campaign.nil?
  puts "❌ Erreur: Campagne de vote 'Sélection pour le Lite Quest de Versailles' non trouvée"
  exit
end

puts "✅ Campagne trouvée: #{lite_quest_campaign.title}"

# Récupérer Valentin Chery
valentin = Player.find_by(first_name: "Valentin", last_name: "Chery")

if valentin.nil?
  puts "❌ Erreur: Valentin Chery non trouvé"
  exit
end

puts "✅ Joueur trouvé: #{valentin.full_name}"

# Récupérer les 25 premiers utilisateurs
users = User.limit(25).to_a

if users.empty?
  puts "❌ Erreur: Aucun utilisateur trouvé"
  exit
end

puts "✅ #{users.count} utilisateurs récupérés"

# Récupérer tous les joueurs de la campagne
campaign_players = lite_quest_campaign.players.to_a
puts "✅ #{campaign_players.count} joueurs dans la campagne"



# 1. Donner 25 votes à Valentin Chery
puts "\n🏀 Attribution de 25 votes à Valentin Chery..."

users.each_with_index do |user, index|
  # Vérifier si l'utilisateur a déjà voté dans cette campagne
  existing_vote = UserVote.find_by(user: user, vote_campaign: lite_quest_campaign)

  if existing_vote
    puts "⚠️  #{user.first_name} #{user.last_name} a déjà voté pour #{existing_vote.player.full_name}"
  else
    UserVote.create!(
      user: user,
      player: valentin,
      vote_campaign: lite_quest_campaign
    )
    puts "✅ Vote #{index + 1}/25 pour #{valentin.full_name} par #{user.first_name} #{user.last_name}"
  end
end

# 2. Créer des votes aléatoires pour les autres utilisateurs
puts "\n🎲 Création de votes aléatoires pour les autres utilisateurs..."

# Générer 50 utilisateurs supplémentaires pour les votes aléatoires
additional_users = User.offset(25).limit(127).to_a

if additional_users.any?
  additional_users.each_with_index do |user, index|
    # Vérifier si l'utilisateur a déjà voté dans cette campagne
    existing_vote = UserVote.find_by(user: user, vote_campaign: lite_quest_campaign)

    if existing_vote
      puts "⚠️  #{user.first_name} #{user.last_name} a déjà voté pour #{existing_vote.player.full_name}"
    else
      # Choisir un joueur aléatoire (y compris Valentin)
      random_player = campaign_players.sample

      UserVote.create!(
        user: user,
        player: random_player,
        vote_campaign: lite_quest_campaign
      )

      puts "✅ Vote aléatoire #{index + 1}/#{additional_users.count}: #{user.first_name} #{user.last_name} vote pour #{random_player.full_name}"
    end
  end
else
  puts "⚠️  Aucun utilisateur supplémentaire trouvé pour les votes aléatoires"
end

# 3. Afficher les statistiques finales
puts "\n📊 STATISTIQUES FINALES:"
puts "=" * 50

total_votes = UserVote.where(vote_campaign: lite_quest_campaign).count
puts "🗳️  Total des votes: #{total_votes}"

puts "\n🏆 Résultats par joueur:"
campaign_players.each do |player|
  vote_count = UserVote.where(vote_campaign: lite_quest_campaign, player: player).count
  percentage = total_votes > 0 ? (vote_count.to_f / total_votes * 100).round(1) : 0
  puts "   #{player.full_name}: #{vote_count} votes (#{percentage}%)"
end

puts "\n✅ Script terminé avec succès!"
puts "🎯 Valentin Chery a reçu 25 votes garantis"
puts "🎲 #{additional_users.count} votes aléatoires ont été distribués"
