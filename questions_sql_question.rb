class Question

  def self.all
    all_questions = QuestionsDB.instance.execute("SELECT * FROM questions")
    all_questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    ids = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    return nil unless ids.length > 0
    Question.new(ids.first)
  end

  def self.find_by_author_id(author_id)
    author_ids = QuestionsDB.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    return nil unless author_ids.length > 0
    Question.new(author_ids.first)
  end

  def self.find_by_title(title)
    titles = QuestionsDB.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL

    return nil unless titles.length > 0
    Question.new(titles.first)
  end

  attr_accessor :title, :body, :author_id
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def create
    raise "#{self} in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @title, @body, @author_id)
      INSERT INTO
        questions(title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id

    QuestionsDB.instance.execute(<<-SQL, @title, @body, @author_id, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?, author_id = ?
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
        users.id = "#{self.author_id}"
    SQL
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end
end
