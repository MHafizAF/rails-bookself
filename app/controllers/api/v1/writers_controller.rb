class Api::V1::WritersController < ApplicationController
  before_action :set_writer, only: %i[ update show destroy ]

  def index 
    @writers = Writer.all 
    response_ok(@writers, 200)
  end  

  def create 
    @writer = Writer.new(writer_params)
    @writer.save ? response_ok(@writer, 200) : 
                 response_error(@writer.errors, 422)
  end

  def update 
    @writer.update(writer_params) ? response_ok(@writer, 200) :
                   response_error(@writer.errors, 422)
  end

  def show 
    response_ok(@writer, 200)
  end

  def destroy
    @writer.destroy 
    response_ok(@writer, 200) 
  end

  private 

  def writer_params 
    params.require(:writer).permit(:name)
  end

  def set_writer 
    @writer = Writer.find_by(id: params[:id])
    response_error("writer not found", 404) if @writer.nil?
  end
end
