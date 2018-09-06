require 'pry'

class Student
  attr_accessor :id, :name, :grade

  # def initialize(name, grade, id=nil)
  #   @name = name
  #   @grade = grade
  #   @id = id
  # end

  def self.new_from_db(row)
    new_student = Student.new

    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]

    new_student

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    all = DB[:conn].execute(sql)

    all.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(search_name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ? limit 1
    SQL

    row = DB[:conn].execute(sql, search_name)[0]

    self.new_from_db(row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    self.all.select do |instance|
      instance.grade == "9"
    end
  end

  def self.students_below_12th_grade
    self.all.select do |instance|
      instance.grade.to_i <= 11
    end
  end

  def self.first_X_students_in_grade_10(x)

    self.all.select do |instance|
      instance.grade == "10"
    end.slice(0, x)

  end

  def self.first_student_in_grade_10
    self.all.find do |instance|
      instance.grade == "10"
    end
  end

  def self.all_students_in_grade_X(x)
    self.all.select do |instance|
      instance.grade.to_i == x
    end
  end



end
