# frozen_string_literal: true

class ViewingPartyController < ApplicationController
  before_action :require_user
  def new
    @viewing_party = ViewingParty.new
    @movie = current_movie
    @users = User.other_users(current_user)
  end

  def create
    party = ViewingParty.new(view_params)
    if party.save && view_params[:duration].to_i >= current_movie.runtime
      creation_factory(party)
      redirect_to user_path, notice: 'View Party created successfully'
    else
      redirect_to new_user_movie_viewing_party_path(params[:movie_id]),
                  notice: 'Error: Incorrect information entered'
    end
  end

  private

  def creation_factory(party)
    user_view_params.each do |user_arr|
      UserViewingParty.create!(user_id: user_arr[0], viewing_party_id: party.id, role: 0) if user_arr[1].to_i == 1
    end
    UserViewingParty.create!(user_id: current_user.id, viewing_party_id: party.id, role: 1)
  end

  def view_params
    params.require(:form_info).permit(:duration, :date, :time, :movie_id)
  end

  def user_view_params
    params.require(:users)
  end

  def current_movie
    MovieFacade.create_individual_movie(params[:movie_id])
  end
end
