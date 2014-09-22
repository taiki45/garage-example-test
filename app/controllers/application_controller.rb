class ApplicationController < ActionController::Base
  include Garage::ControllerHelper

  # Garage's convention
  def current_resource_owner
    @current_resource_owner ||= User.find(resource_owner_id) if resource_owner_id
  end
end
