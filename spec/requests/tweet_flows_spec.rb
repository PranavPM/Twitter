require 'rails_helper'
require 'test_helper'

RSpec.describe "TweetFlows", type: :request do
  test "can see the welcome page" do
    get "/"
    assert_select "h1", "testimonies#index"
  end
end
