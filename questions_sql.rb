require 'sqlite3'
require 'byebug'
require 'singleton'

require_relative 'questions_sql_user'
require_relative 'questions_sql_question'
require_relative 'questions_sql_reply'
require_relative 'questions_sql_questionfollows'

class QuestionsDB < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end
