require 'spec_helper'

describe Document do
  before(:each) do
    @document = Factory(:document, :file => File.open("#{Rails.root}/spec/fixtures/doc.txt"))
  end

	it "should return its name on #to_s" do
		@document.to_s.should == @document.name
	end
	
	it "should have an extension" do
		@document.extension.should == 'txt'
	end
	
	it 'should increase download count by 1' do
	  current_download_count = @document.download_count
	  @document.download_plus_one
	  @document.download_count == current_download_count + 1
  end
	
	describe "validations" do
  	it "should have a name" do
  		Factory.build(:document, :name => nil).should_not be_valid
  	end

		it "should have a file" do
			Factory.build(:document, :file => nil).should_not be_valid
		end
  end
end

# == Schema Information
#
# Table name: documents
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :text
#  file         :string(255)
#  user_id      :integer(4)
#  content_type :string(255)
#  file_size    :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

