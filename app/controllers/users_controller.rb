# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @viewing_parties = @user.viewing_parties
    movies_ids = @viewing_parties.map(&:movie_id)
    @movies = MovieFacade.create_movies(movies_ids)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to "/users/#{@user.id}"
    else
      redirect_to '/register'
      flash[:alert] = "Error: #{error_message(@user.errors)}"

    end
  end

  def login_form; end

  def login_user
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to user_path(user.id)
    else
      flash[:error] = 'Error: Incorrect Credentials'
      render :login_form
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email.downcase, :password, :password_confirmation)
  end
end
