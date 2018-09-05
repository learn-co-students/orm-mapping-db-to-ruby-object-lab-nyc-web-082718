require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end


  def self.all
    # retrieve all the rows from the "Students" database
    sql = "SELECT * FROM students"
    all = DB[:conn].execute(sql)
    # remember each row should be a new instance of the Student class
    all.map { |student| self.new_from_db(student) }
  end


  def self.find_by_name(name)
    # find the student in the database given a name
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    found = DB[:conn].execute(sql, name)
    # return a new instance of the Student class
    found.map { |student| self.new_from_db(student) }.first
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


  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    students = DB[:conn].execute(sql, grade)
    students.map { |student| self.new_from_db(student) }
  end


  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    students = DB[:conn].execute(sql)
    students.map { |student| self.new_from_db(student) }
  end


  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    students = DB[:conn].execute(sql)
    students.map { |student| self.new_from_db(student) }
  end


  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    students = DB[:conn].execute(sql, num)
    students.map { |student| self.new_from_db(student) }
  end


  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    students = DB[:conn].execute(sql)
    students.map { |student| self.new_from_db(student) }.first
  end

end
