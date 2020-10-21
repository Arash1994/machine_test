class User < ApplicationRecord
	has_and_belongs_to_many :conversations, dependent: :destroy
	has_many :messages, dependent: :destroy
	has_many :clear_conversation_histories, dependent: :destroy
	has_one_attached :resume, dependent: :destroy
	# validates :resume, presence: true, blob: {content_type: ['application/pdf'] }
	validate :validate_resume

	
	private
	
	def validate_resume
    if resume.attached? && !resume.content_type.in?(%w(application/pdf))
      errors.add(:resume, 'Must be a PDF file')
    end
  end
end
	