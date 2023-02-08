require 'SQLite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database 
	include Singleton
	def initialize
		super('questions.db')
		self.type_translation = true
		self.results_as_hash = true 
	end
end

class User

	def self.all 
		debugger
		data = QuestionsDatabase.instance.execute('SELECT * FROM users')
		data.map {|row| User.new(row)}
	end

	def initialize(option)
		@id = option['id']
		@fname = option['fname']
		@lname = option['lname']
	end
end