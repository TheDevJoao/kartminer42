class RacersController < ApplicationController
  before_action :show_racer, only: %i[show update]

  def index
    @racers = Racer.all
  end

  def show; end

  def create
    @racer = Racer.new(racer_params)

    if @racer.save
      render :show, status: :ok
    else
      render json: @racer.errors, status: :unprocessable_entity
    end
  end

  def update
    @racer.update(racer_params)

    if @racer.save
      render :show, status: :ok
    else
      render json: @racer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @racer = Racer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @racer = nil
    end

    if @racer.nil?
      render json: { error: 'Racer not found' }, status: :not_found
    else
      @racer.races.clear
      @racer.destroy
      render json: { message: 'Racer deleted' }, status: :ok
    end
  end

  private

  def show_racer
    begin
      @racer = Racer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @racer = nil
    end

    if @racer.nil?
      render json: { error: 'Racer not found' }, status: :not_found
    else
      render :show, formats: [:json], handlers: [:jbuilder]
    end
  end

  def racer_params
    params.require(:racer).permit(:name, :born_at, :image_url)
  end
end
