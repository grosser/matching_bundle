require File.expand_path('spec/spec_helper')

describe MatchingBundle do
  it "has a VERSION" do
    MatchingBundle::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
