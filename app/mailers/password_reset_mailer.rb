class PasswordResetMailer < Devise::Mailer
  def reset_password_instructions(record)
    p "enqueued\n\n\n\n\n\n\n\n"
    Resque.enqueue(EmailSender, :password, record.id)
  end
end