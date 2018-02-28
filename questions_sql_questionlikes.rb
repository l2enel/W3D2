class QuestionLikes

  def self.all
    all_likes = QuestionsDB.instance.execute('SELECT * FROM question_likes')
    all_likes.map { |like| QuestionLikes.new(like) }
  end

  def self.find_by_id(id)
    like = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    return nil unless like.length > 0
    QuestionLikes.new(like.first)
  end

  def self.find_by_question_id(question_id)
    question = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    return nil unless question.length > 0
    QuestionLikes.new(question.first)
  end

  def self.find_by_user_id(user_id)
    user = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL

    return nil unless user.length > 0
    QuestionLikes.new(user.first)
  end

  attr_accessor :question_id, :question, :user_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @question = options['question']
    @user_id = options['user_id']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @question_id, @question, @user_id)
      INSERT INTO
        question_likes(question_id, question, user_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id

    QuestionsDB.instance.execute(<<-SQL, @question_id, @question, @user_id, @id)
      UPDATE
        question_likes
      SET
        question_id = ?, question = ?, user_id = ?
      WHERE
        id = ?
    SQL
  end


end
