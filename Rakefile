require "gemsmith/rake/setup"
Dir.glob("lib/refinements/tasks/*.rake").each { |file| load file }

task default: %w(spec rubocop)
