require 'pry'
class Student
  attr_accessor :id, :name, :grade
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stu_obj = Student.new
    stu_obj.id, stu_obj.name, stu_obj.grade = row[0], row[1], row[2]
    stu_obj
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    stu_arr = DB[:conn].execute("SELECT * FROM students")
    stu_obj_arr = []
    stu_arr.each do |stu|
      tmp = Student.new
      tmp.id, tmp.name, tmp.grade = stu[0], stu[1], stu[2]
      stu_obj_arr.push(tmp)
    end
    stu_obj_arr
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    stu_data = DB[:conn].execute(sql, name)[0]
    stu_obj = Student.new
    stu_obj.id, stu_obj.name, stu_obj.grade = stu_data[0], stu_data[1], stu_data[2]
    stu_obj
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
    self.all.select {|student| student.grade.to_i == 9}
  end

  def self.students_below_12th_grade
    self.all.select {|student| student.grade.to_i < 12}
  end

  def self.first_X_students_in_grade_10(num)
    self.all.select {|student| student.grade.to_i == 10}[0...num]
  end

  def self.first_student_in_grade_10
    self.all.select {|student| student.grade.to_i < 12}.first
  end

  def self.all_students_in_grade_X(num)
    self.all.select {|student| student.grade.to_i == num}
  end
end
