require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(hash = {})
    @id = hash['id']
    @name = hash['name']
    @grade = hash['grade']
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    Student.new({'id' => row[0], 'name' => row[1], 'grade' => row[2]})
  end

  def self.all
    sql = <<-SQL
          SELECT * FROM students
          SQL
    students = DB[:conn].execute(sql)
    students.map do |student|
      self.new_from_db(student)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end


  def self.find_by_name(name)
    sql = <<-SQL
          SELECT * FROM students WHERE name = name
          SQL
     result = DB[:conn].execute(sql).flatten
     self.new_from_db(result)

    # find the student in the database given a name
    # return a new instance of the Student class
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
    sql = <<-SQL
          SELECT * FROM students WHERE grade = 9
          SQL
     students = DB[:conn].execute(sql)
     students.map do |student|
       self.new_from_db(student)
     end
   end

   def self.students_below_12th_grade
     sql = <<-SQL
           SELECT * FROM students WHERE grade < 12
           SQL
      students = DB[:conn].execute(sql)
      students.map do |student|
        self.new_from_db(student)
      end
    end

    def self.first_X_students_in_grade_10(num)
      sql = <<-SQL
            SELECT * FROM students WHERE grade = 10 LIMIT '#{num}'
            SQL
       students = DB[:conn].execute(sql)
       students.map do |student|
         self.new_from_db(student)
       end
     end

     def self.first_student_in_grade_10
       sql = <<-SQL
             SELECT * FROM students WHERE grade = 10 LIMIT 1
             SQL
        student = DB[:conn].execute(sql)[0]
        self.new_from_db(student)
      end

      def self.all_students_in_grade_X(num)
        sql = <<-SQL
              SELECT * FROM students WHERE grade = '#{num}'
              SQL
         students = DB[:conn].execute(sql)
         students.map do |student|
           self.new_from_db(student)
         end
       end

end
