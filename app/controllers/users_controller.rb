class UsersController < ApplicationController
  include Garage::RestfulActions

  private

  def require_resources
    @resources = User.all
  end

  def require_resource
    @resource = User.find(params[:id])
  end

  def update_resource
    @resource.tap {|r| r.update_attributes!(user_params) }
  end

  def respond_with_resources_options
    { paginate: true }
  end

  def respond_with_resource_options
    {
      put: { body: true },
      delete: { body: true }
    }
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
