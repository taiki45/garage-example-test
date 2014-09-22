class UsersController < ApplicationController
  include Garage::RestfulActions

  private

  def require_resources
    @resources = User.all
  end

  def require_resource
    @resource = User.find(params[:id])
  end
end
