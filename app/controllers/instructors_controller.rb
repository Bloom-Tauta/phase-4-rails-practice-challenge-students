class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed_record

  def index
    instructors = Instructor.all
    render json: instructors, status: :ok
  end

  def show
    instructor = find_instructor
    render json: instructor, status: :ok
  end

  def create
    instructor = Instructor.create!(instructor_params)
    render json: instructor, status: :created
  end

  def update
    instructor = find_instructor
    instructor.update!(instructor_params)
    render json: instructor, status: :ok
  end

  def destroy
    instructor = find_instructor
    instructor.destroy!
    head :no_content
  end

private

  def instructor_params
    params.permit(:name)
  end

  def find_instructor
    Instructor.find(params[:id])
  end

  def not_found
    render json: { errors: "Instructor does not exist!!" }, status: :not_found
  end

  def unprocessable_entity(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def not_destroyed_record(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

end
