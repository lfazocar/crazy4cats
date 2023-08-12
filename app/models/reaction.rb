# == Schema Information
#
# Table name: reactions
#
#  id         :bigint           not null, primary key
#  reaction_type       :integer
#  article_id :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Reaction < ApplicationRecord
  # Relations
  belongs_to :article
  belongs_to :user

  # 0 = none, 1 = like, 2 = dislike
  enum :reaction_type, [:no_reaction, :like, :dislike]
end
