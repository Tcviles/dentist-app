class Comment<ActiveRecord::Base
  belongs_to :dentist
  belongs_to :user
  validates_presence_of :content, message: "Must type something!"
end
