class Guess
	include ActiveModel::Model

	attr_accessor :text

	validates :text, presence: true
	validates :text, length: {maximum: 1000}
end