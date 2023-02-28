class RacesController < ApplicationController
  before_action :show_race, only: :show

  def index
    @races = Race.all
  end

  def show; end

  def create
    @race = Race.new(race_params)

    if @race.save
      render :show, status: :ok
    else
      render json: @race.errors, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @race = Race.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @race = nil
    end

    if @race.nil?
      render json: { error: 'Race not found' }, status: :not_found
    else
      @race.destroy
      render json: { message: 'Race deleted' }, status: :ok
    end
  end

  private

  def show_race
    begin
      @race = Race.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @race = nil
    end

    if @race.nil?
      render json: { error: 'Race not found' }, status: :not_found
    else
      render :show, formats: [:json], handlers: [:jbuilder]
    end
  end

  def race_params
    params.require(:race).permit(:tournament_id, :date, :place,
                                 placements_attributes: %i[racer_id position])
  end
end
