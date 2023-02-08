require 'sqlite3'
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
	attr_accessor :id, :fname, :lname

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

	def create
		raise "#{self} already in database" if @id
		QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
			INSERT INTO
				users (fname, lname)
			VALUES
				(?, ?)
		SQL
		@id = QuestionsDatabase.instance.last_insert_row_id
	end

end

# p User.all