Garage.configure {}
Garage::TokenScope.configure do
  register :public do
    access :read, User
    access :write, User
  end
end

Doorkeeper.configure do
  orm :active_record
  default_scopes :public
  optional_scopes(*Garage::TokenScope.optional_scopes)
end
