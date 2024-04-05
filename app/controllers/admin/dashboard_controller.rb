module Admin
    class DashboardController < ApplicationController
      before_action :authenticate_user!
      before_action :check_admin
  
      def index
      end
  
      private
  
      def check_admin
        redirect_to root_path, alert: 'Not authorized' unless current_user.admin?
      end
    end
end
  