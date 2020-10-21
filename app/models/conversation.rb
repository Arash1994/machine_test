class Conversation < ApplicationRecord
	has_and_belongs_to_many :users
	has_many :messages, dependent: :destroy
	has_many :clear_conversation_histories, dependent: :destroy
end
