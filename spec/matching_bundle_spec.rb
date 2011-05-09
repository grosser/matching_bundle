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

  describe :find_matching_local_bundler_version do
    it "find something for >=0" do
      MatchingBundle.find_matching_local_bundler_version('>=0').should =~ /^\d+\.\d+\.\d+$/
    end

    it "finds nothing for >999" do
      MatchingBundle.find_matching_local_bundler_version('>=999').should == nil
    end
  end

  describe :find_matching_remote_bundler_version do
    it "finds one for ~>0.4.0" do
      MatchingBundle.find_matching_remote_bundler_version("~>0.4.0").should == "0.4.1"
    end

    it "does not find one for ~>999" do
      MatchingBundle.find_matching_remote_bundler_version("~>999.0.0").should == nil
    end
  end
end
