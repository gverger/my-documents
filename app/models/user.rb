class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :email, inclusion: {
    in: Rails.application.credentials.dig(:users, :authorized_list),
    message: "%{value} n'est pas un compte autorisé."
  }
end
