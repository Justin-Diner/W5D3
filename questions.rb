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
		data = QuestionsDatabase.instance.execute('SELECT * FROM users')
		data.map {|row| User.new(row)}
	end

	def self.find_by_id(user_id)
		raise "User is not in database" if !user_id
		found_user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
			SELECT 
				* 
			FROM
				users
			WHERE
				id = ?;
		SQL
		User.new(found_user[0])
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

	def update
		raise "#{self} is not in database" if !@id
		QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
			UPDATE
				users
			SET
				fname = ?, lname = ?
			WHERE
				id = ? 
			SQL
	end

end

# No update method currently (due to time)
class Question 
	attr_accessor :title, :body, :user_id

	def self.all 
		data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
		data.map {|row| Question.new(row)}
	end

	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@user_id = options['user_id']
	end

	def create 
		raise "#{self} already in database" if @id
		QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.user_id)
			INSERT INTO
				questions (title, body, user_id)
			VALUES
				(?, ?, ?)
		SQL
		@id = QuestionsDatabase.instance.last_insert_row_id
	end
end

class Like 
	attr_accessor :id, :question_id, :user_id

	def initialize(options)
		@id = options['id']
		@question_id = options['question_id']
		@user_id = options['user_id']
	end

	def self.all
		data = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
		data.map {|row| Like.new(row)}
	end

	def create 
		raise "#{self} already in database" if @id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id)
			INSERT INTO
				question_likes (question_id, user_id)
			VALUES
				(?, ?)
		SQL
		@id = QuestionsDatabase.instance.last_insert_row_id
	end
end
# p User.all