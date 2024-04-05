class LoanDebitJob < ApplicationJob
  queue_as :default

  def perform
    Loan.where(state: 'open').each do |loan|
      user_wallet = loan.user.wallet
      if loan.amount > user_wallet.balance
        Loan.transaction do
          admin_wallet = User.find_by(role: :admin).wallet

          admin_wallet.balance += user_wallet.balance
          user_wallet.balance = 0

          user_wallet.save!
          admin_wallet.save!

          loan.update!(state: 'closed')
        end
      end
    end
  end
end
