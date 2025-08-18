#!/usr/bin/env ruby

# Script de test pour vérifier le fonctionnement du système VoteCampaign
# À exécuter dans la console Rails : rails runner test_vote_campaign.rb

puts "=== Test du système VoteCampaign ==="

# Vérifier que les modèles existent
begin
  puts "1. Vérification des modèles..."
  puts "   - VoteCampaign: #{VoteCampaign.count} campagnes existantes"
  puts "   - Player: #{Player.count} joueurs existants"
  puts "   - VoteCampaignPlayer: #{VoteCampaignPlayer.count} associations existantes"
rescue => e
  puts "   ERREUR: #{e.message}"
end

# Vérifier les associations
begin
  puts "\n2. Vérification des associations..."
  if VoteCampaign.count > 0
    campaign = VoteCampaign.first
    puts "   - Première campagne: #{campaign.title}"
    puts "   - Joueurs associés: #{campaign.players.count}"
    campaign.players.each do |player|
      puts "     * #{player.full_name}"
    end
  else
    puts "   - Aucune campagne existante"
  end
rescue => e
  puts "   ERREUR: #{e.message}"
end

# Test de création d'une nouvelle campagne
begin
  puts "\n3. Test de création d'une campagne..."
  players = Player.limit(3)

  if players.count > 0
    campaign = VoteCampaign.new(
      title: "Test Campaign #{Time.current.to_i}",
      description: "Campagne de test pour vérifier le fonctionnement",
      start_date: Date.current,
      end_date: Date.current + 7.days,
      active: true
    )

    # Assigner les joueurs
    campaign.player_ids = players.pluck(:id)

    if campaign.save
      puts "   ✓ Campagne créée avec succès"
      puts "   - ID: #{campaign.id}"
      puts "   - Joueurs: #{campaign.players.count}"
    else
      puts "   ✗ Erreur lors de la création:"
      campaign.errors.full_messages.each { |msg| puts "     #{msg}" }
    end
  else
    puts "   - Aucun joueur disponible pour le test"
  end
rescue => e
  puts "   ERREUR: #{e.message}"
end

puts "\n=== Test terminé ==="
