require "pry"
class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    Select * from students
    SQL
    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    Select * from students where name = ?
    SQL
    new_student = new_from_db(DB[:conn].execute(sql, name).flatten)
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

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    Select name from students where grade = 9
    SQL

    DB[:conn].execute(sql).flatten
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    Select name from students where grade < 12
    SQL
    DB[:conn].execute(sql).flatten
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
    Select name from students where grade = 10 Limit ?
    SQL

    DB[:conn].execute(sql, x).flatten
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    Select * from students where grade = 10 Limit 1
    SQL
    result = new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
    Select name from students where grade = ?
    SQL

    DB[:conn].execute(sql, x).flatten
  end


end
