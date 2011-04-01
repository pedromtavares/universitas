# == Schema Information
# Schema version: 20110227225207
#
# Table name: group_modules
#
#  id          :integer(4)      not null, primary key
#  group_id    :integer(4)
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class GroupModule < ActiveRecord::Base
	belongs_to :group
	has_many :group_documents
end
