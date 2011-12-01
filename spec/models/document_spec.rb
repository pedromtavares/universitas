require 'spec_helper'

class FakeFile
  attr_accessor :size, :original_filename
  def initialize(name)
    @size = 50
    @original_filename = name.split('/').last
  end
end

describe Document do
  before(:each) do
    @document = Factory(:document, :file => File.open("#{Rails.root}/spec/fixtures/doc.txt"))
    @user = Factory(:user)
  end

	it "should return its name on #to_s" do
		@document.to_s.should == @document.name
	end
	
	it "should have an extension" do
		@document.extension.should == 'txt'
	end
	
	it "should generate an extension based on a filename" do
	  Document.get_extension_from("#{Rails.root}/spec/fixtures/doc.txt").should == 'txt'
	end
	
	it "should determine if an extension is an image or not" do
	  Document.is_image?("txt").should_not be
	  Document.is_image?("png").should be
	end
	
	it "should create a document after sending it do Scribd" do
	  file = FakeFile.new("#{Rails.root}/spec/fixtures/doc.txt")
	  doc = Document.create_from_scribd("test_doc", file, @user, "text/plain")
	  doc.uploader.should == @user
	  doc.file_size.should == file.size
	  doc.content_type.should == "text/plain"
	  doc.name.should == "test_doc"
	  doc.scribd_doc_id.should_not be_blank
	  doc.scribd_access_key.should_not be_blank
	  doc.extension.should == "txt"
	end
	
	describe "validations" do
  	it "should have a name" do
  		Factory.build(:document, :name => nil).should_not be_valid
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

