# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hqmf2js"
  s.summary = "A library for converting HL7 HQMF files to JavaScript"
  s.description = "A library for converting HL7 HQMF files produced by the NQF Measure Authoring Tool to executable JavaScript suitable for use with the popHealth Quality Measure Engine"
  s.email = "talk@projectpophealth.org"
  s.homepage = "http://github.com/pophealth/hqmf2js"
  s.authors = ["Marc Hadley", "Saul Kravitz"]
  s.version = '0.1.0'
  
  s.add_dependency 'nokogiri', '~> 1.4.4'
  
  s.add_development_dependency "awesome_print", "~> 0.3"

  s.files = Dir.glob('lib/**/*.rb') + Dir.glob('lib/**/*.rake') +
            Dir.glob('js/**/*.js*') + ["Gemfile", "README.md", "Rakefile", "VERSION"]
end

