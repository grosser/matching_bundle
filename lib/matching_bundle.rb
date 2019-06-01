# frozen_string_literal: true
require 'open-uri'
require 'json'

module MatchingBundle
  class << self
    def find_or_install_matching_version(gemfile_content)
      return unless requirement = bundler_requirement(gemfile_content)

      if version = find_matching_local_bundler_version(requirement)
        return version
      end

      return unless version = find_matching_remote_bundler_version(requirement)

      warn "Installing bundler #{version}"
      abort unless system "gem", "install", "bundler", "-v", version
      version
    end

    private

    def find_matching_remote_bundler_version(requirement)
      json = open('https://rubygems.org/api/v1/versions/bundler.json').read
      versions = JSON.load(json).map { |v| v["number"] }
      find_satisfied(requirement, versions)
    end

    def find_matching_local_bundler_version(requirement)
      find_satisfied(requirement, installed_bundler_versions)
    end

    def find_satisfied(requirement, versions)
      requirement = Gem::Requirement.new(requirement)
      versions.find do |version|
        requirement.satisfied_by? Gem::Version.new(version)
      end
    end

    def installed_bundler_versions
      Gem::Specification.
        find_all { |s| s.name == 'bundler' }.
        map { |spec| spec.version.to_s }
    end

    def bundler_requirement(gemfile_content)
      found = gemfile_content.scan(/^\s*bundler \((.*)\)/)
      versions = found.map(&:last)
      versions.find { |version| version =~ /^=\s*\d/ } || versions.first
    end
  end
end
