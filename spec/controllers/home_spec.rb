# home_spec.rb

require 'spec_helper'

describe "home" do
  it "should be ok" do
    get '/'
    expect(last_response).to be_ok
  end
end