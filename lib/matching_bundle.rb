class MatchingBundle
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

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
