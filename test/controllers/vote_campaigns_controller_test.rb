require "test_helper"

class VoteCampaignsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vote_campaigns_index_url
    assert_response :success
  end

  test "should get show" do
    get vote_campaigns_show_url
    assert_response :success
  end

  test "should get vote" do
    get vote_campaigns_vote_url
    assert_response :success
  end
end
