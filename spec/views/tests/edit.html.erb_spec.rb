require 'spec_helper'

describe "tests/edit.html.erb" do
  before(:each) do
    @test = assign(:test, stub_model(Test,
      :new_record? => false,
      :hi => "MyString"
    ))
  end

  it "renders the edit test form" do
    render

    rendered.should have_selector("form", :action => test_path(@test), :method => "post") do |form|
      form.should have_selector("input#test_hi", :name => "test[hi]")
    end
  end
end
