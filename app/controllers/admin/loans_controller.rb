module Admin
  class LoansController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_loan, only: [:show, :update]

    def index
      @loans = Loan.where(state: 'requested')
    end

    def show
    end

    def update
      if params[:loan][:state] == 'approved'
        @loan.interest_rate = params[:loan][:interest_rate] if params[:loan][:interest_rate].present?
        @loan.approved!
      elsif params[:loan][:state] == 'rejected'
        @loan.rejected!
      end

      if @loan.save
        redirect_to admin_loans_path, notice: 'Loan request has been processed.'
      else
        render :show
      end
    end

    private

    def ensure_admin
      redirect_to root_path unless current_user.admin?
    end

    def set_loan
      @loan = Loan.find(params[:id])
    end
  end
end
  