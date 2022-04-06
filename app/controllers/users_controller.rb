# frozen_string_literal: true

class UsersController < ApplicationController
  before_action do
    @certificate_authority = current_user.certificate_authorities.find(params[:certificate_authority_id])
  end

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path"
  add_breadcrumb :certificate_authority_title, "certificate_authority_path(@certificate_authority)"

  def index
    @users = User.all
  end

  def grant
    @user = User.find(params[:id])
    @certificate_authority.users << @user unless @certificate_authority.users.include?(@user)
    redirect_to certificate_authority_users_path(@certificate_authority)
  end

  def revoke
    @user = User.find(params[:id])
    @certificate_authority.users.delete(@user)
    redirect_to certificate_authority_users_path(@certificate_authority)
  end
end
