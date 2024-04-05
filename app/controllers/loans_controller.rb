class LoansController < ApplicationController
    before_action :authenticate_user!
    before_action :set_loan, only: [:show, :update, :destroy, :repay, :confirm, :reject]
  
    def index
      @loans = current_user.loans
    end
  
    def show
    end
  
    def new
      @loan = current_user.loans.build
    end
  
    def create
        @loan = current_user.loans.build(loan_params)
        if @loan.save
          redirect_to @loan, notice: 'Loan request submitted successfully.'
        else
          render :new
        end
    end
      
    def update
      if @loan.update(loan_params)
        redirect_to @loan, notice: 'Loan updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @loan.destroy
      redirect_to loans_url, notice: 'Loan was successfully canceled.'
    end
    
    def repay
        if @loan.present?
          if current_user.wallet.balance >= @loan.amount
            Loan.transaction do
              user_wallet = current_user.wallet
              admin_wallet = User.find_by(role: :admin).wallet
      
              user_wallet.balance -= @loan.amount
              admin_wallet.balance += @loan.amount
      
              user_wallet.save!
              admin_wallet.save!
              @loan.update!(state: 'closed')
      
              redirect_to loans_path, notice: 'Loan has been repaid successfully and is now closed.'
            end
          else
            redirect_to @loan, alert: 'Insufficient balance to repay the loan.'
          end
        else
          redirect_to loans_path, alert: 'Loan not found.'
        end
      rescue ActiveRecord::RecordInvalid => e
        redirect_to @loan, alert: "There was an error during repayment: #{e.message}"
    end
      

    def confirm
        if @loan.approved?
          Loan.transaction do
            admin_wallet = User.find_by(role: :admin).wallet
            user_wallet = current_user.wallet
    
            admin_wallet&.balance -= @loan&.amount
            user_wallet&.balance += @loan&.amount
    
            admin_wallet&.save!
            user_wallet&.save!
            @loan.update!(state: 'open')
          end
    
          redirect_to @loan, notice: 'Loan has been confirmed and funds have been transferred.'
        else
          redirect_to @loan, alert: 'Loan cannot be confirmed in its current state.'
        end
      rescue ActiveRecord::RecordInvalid => e
        redirect_to @loan, alert: "There was an error confirming the loan: #{e.message}"
    end
    
    def reject
        if @loan.approved?
          @loan.update!(state: 'rejected')
          redirect_to @loan, notice: 'Loan has been rejected.'
        else
          redirect_to @loan, alert: 'Loan cannot be rejected in its current state.'
        end
    end
  
    private
  
    def set_loan
      @loan = current_user.loans.find(params[:id])
    end
  
    def loan_params
      params.require(:loan).permit(:amount, :interest_rate)
    end
end
  