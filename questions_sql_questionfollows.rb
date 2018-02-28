class QuestionFollows

  def self.all
    all_follows = QuestionsDB.instance.execute('SELECT * FROM question_follows')
    all_follows.map { |follow| QuestionFollows.new(follow) }
  end

  def self.find_by_id(id)
    follow = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    return nil unless follow.length > 0
    QuestionFollows.new(follow.first)
  end

  def self.find_by_user_id(user_id)
    user = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL

    return nil unless user.length > 0
    QuestionFollows.new(user.first)
  end

  def self.find_by_question_id(question_id)
    question = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL

    return nil unless question.length > 0
    QuestionFollows.new(question.first)
  end

  def self.followers_for_question_id(question_id)
    QuestionsDB.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.user_id
      WHERE
        question_follows.question_id = question_id
    SQL
  end

  def self.followers_for_user_id(user_id)
    QuestionsDB.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = user_id
    SQL
  end

  attr_accessor :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @user_id, @question_id)
      INSERT INTO
        question_follows(user_id, question_id)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id

    QuestionsDB.instance.execute(<<-SQL, @user_id, @question_id, @id)
      UPDATE
        question_follows
      SET
        user_id = ?, question_id = ?
      WHERE
        id = ?
    SQL
  end
end
