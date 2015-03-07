class SessionsController < Clearance::SessionsController
  layout 'simple'

  def create_from_omniauth
    user = headquarters_user(auth_hash.info.email)

    if user.persisted?
      handle_success(user)
    else
      handle_failure
    end
  end

  def url_after_destroy
    log_in_url
  end

  private

  def handle_success(user)
    sign_in(user)
    redirect_to root_url
  end

  def handle_failure
    redirect_to root_url
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def headquarters_user(email)
    data = Headquarters::Client::Members.new.search(email).first
    return if data.nil?

    find_or_create_from_headquarters(data)
  end

  def find_or_create_from_headquarters(data)
    User.where(email: data['email']).first_or_create do |user|
      user.name = data['name']
      user.email = data['email']
      user.password = SecureRandom.hex(20)
    end
  end
end
