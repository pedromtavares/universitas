require 'spec_helper'

describe "tests/show.html.haml" do
  before(:each) do
    @test = assign(:test, stub_model(Test,
      :oi => "Oi"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Oi".to_s)
  end
end
