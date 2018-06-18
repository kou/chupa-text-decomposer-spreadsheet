# -*- mode: ruby; coding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = "chupa-text-decomposer-spreadsheet"
  spec.version = "1.0.2"
  spec.author = "Kenji Okimoto"
  spec.email = "okimoto@clear-code.com"
  spec.summary = "ChupaText decomposer for spreadsheet."
  spec.description = spec.summary
  spec.license = "MIT"
  spec.files = ["#{spec.name}.gemspec"]
  spec.files += Dir.glob("{README*,LICENSE*,Rakefile,Gemfile}")
  spec.files += Dir.glob("doc/text/*")
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("test/fixture/**/*")
  spec.files += Dir.glob("test/**/*.rb")

  spec.add_runtime_dependency("chupa-text")
  spec.add_runtime_dependency("roo")
  spec.add_runtime_dependency("roo-xls")

  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("test-unit")
end
