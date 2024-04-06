require_relative "lib/lazy_filler/version"

Gem::Specification.new do |spec|
  spec.name = "lazy_filler"
  spec.version = LazyFiller::VERSION
  spec.authors = ["Mikkel Malmberg"]
  spec.email = ["mikkel@brnbw.com"]
  spec.homepage = "https://github.com/mikker/lazy_filler"
  spec.summary = "Summary of Lazy::Filler."
  spec.description = "Description of Lazy::Filler."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency("rails", ">= 7.1.3.2")
end
