# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  SIGNUP_URL = 'https://pyramid-front.herokuapp.com'

  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :authenticaate_user_using_x_auth_token, only: [:create]

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def standings
    users = User.all
    standings = users.map { |user| [user.email, [user.name, user.total_points]] }.sort { |a| a[1][1] }.to_h
    render json: { points_standings: standings }, status: 200
  end

  def invite
    user = User.find_by(authentication_token: request.headers["X-Auth-Token"], email: request.headers["X-Auth-Email"] )
    render json: { invite_link: "#{SIGNUP_URL}?invite_token=#{user.invite_token}" }, status: 200
  end

  def get_lucky
    user = User.find_by(authentication_token: request.headers["X-Auth-Token"], email: request.headers["X-Auth-Email"] )
    respond_with_error 'You have maxed out your luck', 401 unless user&.valid_for_get_lucky?

    lucky_points = PointTransaction.get_lucky(user)
    render json: { points_recieved: lucky_points }, status: 200
  end

  def show
    if @user
      render json: @user
    else
      respond_with_error "User with id #{params[:id]} not found.", :not_found
    end
  end

  def create
    inviting_user_id = Invitation.find_by(invited_email: user_params[:email])&.user_id
    user = User.create(user_params.merge({ parent_id: inviting_user_id }))

    if user.valid?
      sign_in(user)
      render json: { user: user, auth_token: user.authentication_token }
    else
      render json: { error: user.errors.full_messages.to_sentence }, status: 422
    end
  end

  def update
    if @user.blank?
      respond_with_error "User with id #{params[:id]} not found.", :not_found

    elsif @user.update(user_params)
      render json: @user

    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: 422
    end
  end

  def destroy
    if @user.blank?
      respond_with_error "User with id #{params[:id]} not found.", :not_found

    elsif @user.destroy
      render json: @user

    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
