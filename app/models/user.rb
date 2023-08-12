# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           not null
#  role                   :integer          default("user")
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 0 = user, 1 = admin
  enum :role, [:user, :admin]

  # Relations
  has_many :articles
  has_many :comments, dependent: :nullify
  has_many :reactions, dependent: :destroy

  # Validations
  validates :username, uniqueness: true, presence: true
end
