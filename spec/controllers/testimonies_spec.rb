require 'rails_helper'

RSpec.describe TestimoniesController, type: :controller do
  before(:all) do
    @test_1 = Testimony.create(tweet_id: 'tweet_1', screen_name: 'screen_1' ,content: 'content_1')
    @test_2 = Testimony.create(tweet_id: 'tweet_2', screen_name: 'screen_2' ,content: 'content_2')
  end

  it '#index' do
    get :index
    expect(response).to have_http_status(200)
    expect(response).to render_template(:index)
    
  end

  it "destroy record" do
    expect{delete :destroy}.to change{Testimony.all.count}
  end

  it "redirect_to index after destroy" do
    delete :destroy
    expect(response).to redirect_to(root_path)
  end

end
