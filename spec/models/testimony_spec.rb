require 'rails_helper'

RSpec.describe Testimony, :type => :model do
  subject { described_class.new }
  it "is valid with valid attributes" do
    subject.tweet_id = "Anything"
    subject.screen_name = "Anything"
    subject.content = "Anything"
    expect(subject).to be_valid
    expect(Testimony.new(tweet_id: 'Anything',screen_name: 'Anything',content: 'Anything')).to be_valid
  end

  it "is not valid without a tweet_id" do
    expect(subject).to_not be_valid
  end
  it "is not valid without a screen_name" do
    expect(subject).to_not be_valid
  end
  it "is not valid without a content" do
    expect(subject).to_not be_valid
  end

end
