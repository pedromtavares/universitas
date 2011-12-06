class EmailSender
  @queue = :emails_queue
  
  def self.perform(type, data)
    case type
    when 'contact'
      Notifications.contact_us(data).deliver
		when 'password'
      user = User.find(data)
      Devise::Mailer.reset_password_instructions(user).deliver
		end
  end
end