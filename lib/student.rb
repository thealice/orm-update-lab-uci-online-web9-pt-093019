require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    self.create_table
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
      name = row[1]
      grade = row[2]
      new_student = self.new(name, grade)

      new_student.id = row[0]
/


  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
