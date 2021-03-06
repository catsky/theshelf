# http://robots.thoughtbot.com/faster-tests-sign-in-through-the-back-door
class ClearanceBackDoor
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    sign_in_through_the_back_door
    @app.call(@env)
  end

  private

  def sign_in_through_the_back_door
    user_id = params['as']
    if user_id
      user = User.find(user_id)
      @env[:clearance].sign_in(user)
    end
  end

  def params
    Rack::Utils.parse_query(@env['QUERY_STRING'])
  end
end

TheShelf::Application.configure do
  config.cache_classes = true

  config.eager_load = false

  config.serve_static_files  = true
  config.static_cache_control = "public, max-age=3600"

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.active_support.deprecation = :stderr

  config.middleware.use ClearanceBackDoor
end
