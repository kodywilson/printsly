Gem::Specification.new do |s|
  s.name         = 'printsly'
  s.version      = '0.0.1'
  s.date         = '2015-03-12'
  s.summary      = "Printer management software"
  s.description  = "Helps you add printers to CUPS"
  s.authors      = ["Kody Wilson"]
  s.email        = 'kodywilson@gmail.com'
  s.files        = ["lib/printsly.rb", "lib/common_stuff.rb", "lib/printers.rb", "lib/choice.rb", "lib/menu.rb", "lib/show_text.rb", "lib/test_data"]
  s.homepage     = 'https://github.com/kodywilson/printsly'
  s.executables  << 'printsly'
  s.license      = 'MIT'
  s.add_runtime_dependency 'spreadsheet', '~> 1.0.3', '>= 1.0.3'
  s.add_runtime_dependency 'colorize', '~> 0.7.5', '>= 0.7.5'
end
