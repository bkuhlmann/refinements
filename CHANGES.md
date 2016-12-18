# v3.2.0 (2016-12-18)

- Fixed README `#symbolize_keys` typo.
- Fixed Rakefile support for RSpec, Reek, Rubocop, and SCSS Lint.
- Added `Gemfile.lock` to `.gitignore`.
- Updated Travis CI configuration to use defaults.
- Updated to Gemsmith 8.2.x.
- Updated to Rake 12.x.x.
- Updated to Rubocop 0.46.x.
- Updated to Ruby 2.3.2.
- Updated to Ruby 2.3.3.

# v3.1.0 (2016-11-13)

- Added Code Climate engine support.
- Added Reek support.
- Added `Hash#slice` and `Hash#slice!` support.
- Added `Hash#symbolize_keys` and `Hash#symbolize_keys!` support.
- Updated to Code Climate Test Reporter 1.0.0.
- Updated to Gemsmith 8.0.0.
- Refactored source requirements.

# v3.0.0 (2016-11-01)

- Fixed #camelcase, #snakecase, and #titleize delimiter string transforms.
- Fixed Rakefile to safely load Gemsmith tasks.
- Added Hash#compact and Hash#compact! deprecation warnings.
- Added `String#blank?` refinement.
- Added `String#down` refinement.
- Added first letter string capitalization support.
- Added frozen string literal pragma.
- Updated README to mention "Ruby" instead of "MRI".
- Updated README versioning documentation.
- Updated RSpec temp directory to use Bundler root path.
- Updated gemspec with conservative versions.
- Updated to Gemsmith 7.7.0.
- Updated to RSpec 3.5.0.
- Updated to Rubocop 0.44.
- Removed "Extensions" suffix from all refinements.
- Removed CHANGELOG.md (use CHANGES.md instead).
- Removed Rake console task.
- Removed gemspec description.
- Removed rb-fsevent development dependency from gemspec.
- Removed terminal notifier gems from gemspec.
- Refactored RSpec spec helper configuration.
- Refactored gemspec to use default security keys.

# v2.2.1 (2016-05-14)

- Fixed camelcase issue where downcased string wasn't capitalized.
- Updated to Ruby 2.3.1.

# v2.2.0 (2016-04-19)

- Fixed README gem certificate install instructions.
- Fixed contributing guideline links.
- Added GitHub issue and pull request templates.
- Added Hash `#compact` and `#compact!` methods.
- Added Rubocop Style/SignalException cop style.
- Added String extensions.
- Added bond, wirb, hirb, and awesome_print development dependencies.
- Updated GitHub issue and pull request templates.
- Updated README secure gem install documentation.
- Updated Rubocop PercentLiteralDelimiters and AndOr styles.
- Updated to Code of Conduct, Version 1.4.0.
- Refactored version label method name.

# v2.1.0 (2016-01-20)

- Fixed secure gem install issues.
- Added frozen string literal to source files.
- Removed frozen string literal support from Rake files.

# v2.0.0 (2016-01-16)

- Fixed README URLs to use HTTPS schemes where possible.
- Added Hash refinements.
- Added IRB development console Rake task support.
- Added README requirement for Ruby refinements and lexical scope.
- Added Rubocop Style/StringLiteralsInInterpolation cop.
- Updated to Ruby 2.3.0.
- Removed RSpec default monkey patching behavior.
- Removed Ruby 2.1.x and 2.2.x support.

# v1.0.0 (2015-11-21)

- Fixed README test command instructions.
- Fixed gemspec homepage URL.
- Added Gemsmith development support.
- Added Patreon badge to README.
- Added Rubocop support.
- Added [pry-state](https://github.com/SudhagarS/pry-state) support.
- Added project name to README.
- Added table of contents to README.
- Updated Code Climate to run when CI ENV is set.
- Updated Code of Conduct 1.3.0.
- Updated README with Tocer generated Table of Contents.
- Updated RSpec support kit with new Gemsmith changes.
- Updated gemspec summary and description.
- Updated to Code Climate SVG badge icons.
- Updated to Ruby 2.2.3.
- Removed auto-loading of each refinement when gem is required.
- Removed required Ruby version from gemspec.
- Removed unnecessary exclusions from .gitignore.
- Refactored Identity module to use string interpolation for version label.
- Refactored RSpec Pry support as an extension.

# v0.1.0 (2015-07-19)

- Initial version.
