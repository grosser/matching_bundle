# frozen_string_literal: true
require_relative "test_helper"

SingleCov.covered!

describe MatchingBundle do
  def capture_stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = STDERR
  end

  it "has a VERSION" do
    MatchingBundle::VERSION.must_match /^[\.\da-z]+$/
  end

  describe ".find_or_install_matching_version" do
    before { MatchingBundle.expects(:system).with { raise }.never } # block up when trying to install

    it "does nothing when bundler is not set" do
      MatchingBundle.find_or_install_matching_version("foo").must_be_nil
    end

    it "prefer local version when available" do
      capture_stderr do
        MatchingBundle.find_or_install_matching_version("bundler (#{Bundler::VERSION})").
          must_equal Bundler::VERSION
      end.must_equal "Found bundler #{Bundler::VERSION}\n"
    end

    it "cannot find version that does not exist remotely" do
      MatchingBundle.find_or_install_matching_version("bundler (12.13.14)").must_be_nil
    end

    it "installs missing remote version" do
      MatchingBundle.unstub(:system)
      MatchingBundle.expects(:system).
        with("gem", "install", "bundler", "-v", "1.2.0.pre").
        returns(true)
      capture_stderr do
        MatchingBundle.find_or_install_matching_version("bundler (1.2.0.pre)").must_equal "1.2.0.pre"
      end.must_equal "Installing bundler 1.2.0.pre\n"
    end

    it "stops when failing to install missing version" do
      MatchingBundle.unstub(:system)
      MatchingBundle.expects(:system).returns(false)
      capture_stderr do
        assert_raises SystemExit do
          MatchingBundle.find_or_install_matching_version("bundler (1.2.0.pre)").must_equal "1.2.0.pre"
        end
      end.must_equal "Installing bundler 1.2.0.pre\n"
    end
  end

  describe ".bundler_requirement" do
    def requirements(*args)
      MatchingBundle.send(:bundler_requirements, *args)
    end

    it "finds nothing when there is nothing" do
      requirements("").must_equal []
    end

    it "finds a direct requirement" do
      gemfile = "asd\n  bundler (1.0.1)"
      requirements(gemfile).must_equal ["1.0.1"]
    end

    it "finds a indirect requirement" do
      gemfile = "asd\n    bundler (~>1.0.1)"
      requirements(gemfile).must_equal ["~>1.0.1"]
    end

    it "finds dependencies too" do
      gemfile = "asd\n    bundler (~>1.0.1)\nDEPENDENCIES\n  bundler (= 1.1.0.rc)"
      requirements(gemfile).must_equal ["~>1.0.1", "= 1.1.0.rc"]
    end

    it "can find from failed bundle lock input" do
      input = <<-TXT.gsub(/^        /, "")
        Fetching gem metadata from https://rubygems.org/..........
        Fetching gem metadata from https://rubygems.org/.
        Resolving dependencies...
        Bundler could not find compatible versions for gem "bundler":
          In rails3.2.gemfile:
            bundler (~> 1.3)
        
          Current Bundler version:
            bundler (2.0.1)
        This Gemfile requires a different version of Bundler.
        Perhaps you need to update Bundler by running `gem install bundler`?
        
        Could not find gem 'bundler (~> 1.3)' in any of the relevant sources:
          the local ruby installation
      TXT
      requirements(input).must_equal ["~> 1.3"]
    end
  end

  describe ".find_satisfied" do
    it "finds simple" do
      MatchingBundle.send(:find_satisfied, ['>=0'], ["1.2.3", "1.3.4"]).must_equal "1.3.4"
    end

    it "finds complex" do
      MatchingBundle.send(:find_satisfied, ['>=0', '~>1.2.0', '<=3'], ["1.2.3", "1.3.4"]).must_equal "1.2.3"
    end

    it "sorts logically" do
      MatchingBundle.send(:find_satisfied, ['>=0'], ["1.2.3", "1.20.3", "1.3.3"]).must_equal "1.20.3"
    end
  end

  describe ".installed_bundler_versions" do
    it "finds something" do
      expected = `gem list bundler | grep bundler`.strip.match(/\((.*)\)/)[1].split(', ')
      MatchingBundle.send(:installed_bundler_versions).must_equal expected
    end
  end

  describe ".find_matching_local_bundler_version" do
    it "find something for >=0" do
      MatchingBundle.send(:find_matching_local_bundler_version, '>=0').must_match /^\d+\.\d+\.\d+$/
    end

    it "finds nothing for >999" do
      MatchingBundle.send(:find_matching_local_bundler_version, '>=999').must_be_nil
    end
  end

  describe ".find_matching_remote_bundler_version" do
    it "finds one for ~>0.4.0" do
      MatchingBundle.send(:find_matching_remote_bundler_version, "~>0.4.0").must_equal "0.4.1"
    end

    it "does not find one for ~>999" do
      MatchingBundle.send(:find_matching_remote_bundler_version, "~>999.0.0").must_be_nil
    end
  end
end
