# frozen_string_literal: true
require 'open-uri'
require 'json'

module MatchingBundle
  class << self
    def find_or_install_matching_version(gemfile_content)
      requirements = bundler_requirements(gemfile_content)
      return if requirements.empty? # just use whatever

      if version = find_matching_local_bundler_version(requirements)
        warn "Using installed bundler #{version}"
        return version
      end

      unless version = find_matching_remote_bundler_version(requirements)
        warn "No remote version of bundler satisfies #{requirements.join(", ")}"
        return
      end

      warn "Installing bundler #{version}"
      abort unless system "gem", "install", "bundler", "-v", version
      version
    end

    private

    def find_matching_remote_bundler_version(requirements)
      json = open('https://rubygems.org/api/v1/versions/bundler.json').read
      versions = JSON.load(json).map { |v| v["number"] }
      find_satisfied(requirements, versions)
    end

    def find_matching_local_bundler_version(requirements)
      find_satisfied(requirements, installed_bundler_versions)
    end

    def find_satisfied(requirements, versions)
      requirement = Gem::Requirement.new(*requirements)
      version = versions.map { |v| Gem::Version.new(v) }.sort!.reverse!.find do |version|
        requirement.satisfied_by? version
      end
      version.to_s if version
    end

    def installed_bundler_versions
      Gem::Specification.
        find_all { |s| s.name == 'bundler' }.
        map { |spec| spec.version.to_s }
    end

    def bundler_requirements(gemfile_content)
      requirements =
        gemfile_content.
          split("Current Bundler version").first.to_s.
          scan(/^\s*bundler \((.*)\)/).flatten.
          flat_map { |r| r.split(", ") }

      # saw 2.2.16 fail on 2.2.3 ... so we need exact match
      if gemfile_content =~ /BUNDLED WITH\n\s+(.*)/
        requirements << "= #{$1}"
      end

      requirements
    end
  end
end
