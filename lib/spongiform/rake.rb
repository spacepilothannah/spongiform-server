require 'rake'

Rake.application.init('spongiform-rake')
Rake.load_rakefile(File.join(__dir__,'..','..','Rakefile'))

Rake.application.run
