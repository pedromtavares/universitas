# == Schema Information
# Schema version: 20110227225207
#
# Table name: authentications
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Authentication < ActiveRecord::Base
	PROVIDERS = ['twitter', 'facebook']
	belongs_to :user
end
