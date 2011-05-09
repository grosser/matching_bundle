require File.expand_path('spec/spec_helper')

describe MatchingBundle do
  it "has a VERSION" do
    MatchingBundle::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  describe :bundler_requirement do
    it "finds nothing when there is nothing" do
      MatchingBundle.bundler_requirement("").should == nil
    end

    it "finds a direct requirement" do
      MatchingBundle.bundler_requirement("asd\n  bundler (1.0.1)").should == "1.0.1"
    end

    it "finds a indirect requirement" do
      MatchingBundle.bundler_requirement("asd\n    bundler (~>1.0.1)").should == "~>1.0.1"
    end
  end

  describe :installed_bundler_versions do
    it "finds something" do
      expected = `gem list bundler | grep bundler`.strip.match(/\((.*)\)/)[1].split(', ')
      MatchingBundle.installed_bundler_versions.should =~ expected
    end
  end
end
