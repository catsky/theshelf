module UserRoles
  ROLES = %w(
    registered
    admin
  )
  private_constant :ROLES

  def self.all
    ROLES
  end

  def self.initial_role
    ROLES.first
  end
end
