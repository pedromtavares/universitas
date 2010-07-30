require 'spec_helper'

describe "tests/show.html.erb" do
  before(:each) do
    @test = assign(:test, stub_model(Test,
      :hi => "Hi"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Hi".to_s)
  end
end
