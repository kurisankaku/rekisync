# User service.
class UserService
  # Find an user by specified id.
  #
  # @param [Integer] id an user id.
  # @param [Symbol] field specified error field, default is id.
  def find(id, field = :id)
    User.find_by_id(id) || (fail BadRequestError.resource_not_found(field), "User not found.")
  end

  # Find an user by specified name.
  #
  # @param [String] name an user name.
  # @param [Symbol] field specified error field, default is name.
  def find_by_name(name, field = :name)
    User.find_by_name(name) || (fail BadRequestError.resource_not_found(field), "User not found.")
  end
end
