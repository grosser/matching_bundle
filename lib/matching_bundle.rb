require 'open-uri'

class MatchingBundle
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  def self.find_or_install_matching_version(gemfile_content)
    return unless requirement = bundler_requirement(gemfile_content)

    if version = find_matching_local_bundler_version(requirement)
      return version
    end

    if version = find_matching_remote_bundler_version(requirement)
      $stderr.puts "installing bundler #{version}"
      `gem install bundler -v #{version}`
      return version
    end
  end

  def self.find_matching_remote_bundler_version(requirement)
    json = open('http://rubygems.org/api/v1/versions/bundler').read
    versions = json.scan(/"number"\s*:\s*"(.*?)"/).map{|v|v.first}
    find_satisfied(requirement, versions)
  end

  def self.find_matching_local_bundler_version(requirement)
    find_satisfied(requirement, installed_bundler_versions)
  end

  def self.find_satisfied(requirement, versions)
    requirement = Gem::Requirement.new(requirement)
    versions.find do |version|
      requirement.satisfied_by? Gem::Version.new(version)
    end
  end

  def self.installed_bundler_versions
    bundler_specs = if Gem::Specification.respond_to?(:find_all)
      Gem::Specification.find_all{|s| s.name == 'bundler' }
    else
      dep = Gem::Dependency.new 'bundler', Gem::Requirement.default
      Gem.source_index.search dep
    end
    bundler_specs.map{|spec| spec.version.to_s }
  end

  def self.bundler_requirement(gemfile_content)
    if found = gemfile_content.match(/^\s*bundler \((.*)\)/)
      found[1]
    end
  end
end
