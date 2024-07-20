class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  def index
    students = Student.all
    render json: students, status: :ok
  end

  def show
    student = find_student
    render json: student, status: :ok
  end

  def create
    instructor = Instructor.find(params[:instructor_id])
    student = instructor.students.create!(student_params)
    render json: student, status: :created
  end

  def update
    instructor= Instructor.find(params[:instructor_id])
    student = instructor.students.update!(student_params)
    render json: student, status: :ok
  end

  def destroy
    student = find_student
    student.destroy!
    head :no_content
  end

  private

  def find_student
    Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :major, :age)
  end

  def not_found
    render json: { errors: "Student not found!!" }, status: :not_found
  end

  def unprocessable_entity(e)
    render json: { errors: e.record.erros }, status: :unprocessable_entity
  end

  def record_not_destroyed
    render json: { errors: e.record.erros }, status: :unprocessable_entity
  end

end
