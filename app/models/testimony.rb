class Testimony < ApplicationRecord
  # validates :tweet_id, :screen_name ,:content, presence: true
  validates_presence_of :tweet_id,:content,:screen_name

end
