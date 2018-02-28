require 'byebug'

class Reply

  def self.all
    all_replies = QuestionsDB.instance.execute('SELECT * FROM replies')
    all_replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_id(id)
    responses = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    return nil if responses.empty?
    Reply.new(responses.first)
  end

  def self.find_by_parent_id(parent_id)
    parents = QuestionsDB.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    return nil if parents.empty?
    Reply.new(parents.first)
  end

  def self.find_by_user_id(user_id)
    user_ids = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    return nil if user_ids.empty?
    Reply.new(user_ids.first)
  end

  def self.find_by_question_id(question_id)
    question_ids = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    return nil if question_ids.empty?
    Reply.new(question_ids.first)
  end

  attr_accessor :parent_id, :user_id, :question_id, :body
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @body = options['body']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @parent_id, @user_id, @question_id, @body)
      INSERT INTO
        replies(parent_id, user_id, question_id, body)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id

    QuestionsDB.instance.execute(<<-SQL, @parent_id, @user_id, @question_id, @body, @id)
      UPDATE
        replies
      SET
        parent_id = ?, user_id = ?, question_id = ?, body = ?
      WHERE
        id = ?
    SQL
  end

  def author
    QuestionsDB.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = "#{self.user_id}"
    SQL
  end

  def question
    QuestionsDB.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = "#{self.question_id}"
    SQL
  end

  def parent_reply
    QuestionsDB.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = "#{self.parent_id}"
    SQL
  end

  def child_replies
    QuestionsDB.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_id = "#{self.id}"
    SQL
  end
end
