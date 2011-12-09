class PasswordResetMailer < Devise::Mailer
  def reset_password_instructions(record)
    Resque.enqueue(EmailSender, :password, record.id)
  end
end