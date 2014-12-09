module API
  module V1
    class ApplicationController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include ActionController::Serialization
      include CanCan::ControllerAdditions

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActionController::ParameterMissing, with: :parameter_missing

      before_action :authenticate

      check_authorization

      # necessary to return the right content type and response body
      ActionController::Renderers.add :json_vendored do |resource, options|
        new_content_type = nil

        request.accepts.each do |accept|
          if accept.to_s =~ /(application\/vnd\.theshelf-v\d+\+json)/ && new_content_type.nil?
            new_content_type = $1
          end
        end

        self.content_type = new_content_type
        self.response_body = _render_option_json(resource, options)
      end

      private

      def authenticate
        authenticate_user_from_token! || unauthorized
      end

      def authenticate_user_from_token!
        authenticate_with_http_token do |token|
          user = User.where(authentication_token: token).first

          if user
            sign_in user, store: false
          end
        end
      end

      def unauthorized
        headers['WWW-Authenticate'] = 'Token realm="Application"'

        render json_vendored: 'Bad credentials', status: :unauthorized
      end

      def record_not_found
        head :not_found
      end

      def parameter_missing
        head :bad_request
      end
    end
  end
end
