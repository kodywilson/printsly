Gem::Specification.new do |s|
  s.name         = 'printsly'
  s.version      = '0.0.0'
  s.date         = '2015-01-27'
  s.summary      = "Printer management software"
  s.description  = "Helps you add printers to CUPS"
  s.authors      = ["Kody Wilson"]
  s.email        = 'kodywilson@gmail.com'
  s.files        = ["lib/printsly.rb"]
  s.homepage     = 'https://github.com/kodywilson/printsly'
  s.executables  << 'printsly'
  s.license      = 'MIT'
  s.add_runtime_dependency 'spreadsheet', '~> 1.0.0', '>= 1.0.0'
end
