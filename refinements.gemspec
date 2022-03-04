# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "refinements"
  spec.version = "9.3.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/refinements"
  spec.summary = "A collection of refinements to core Ruby objects."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/refinements/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/refinements/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/refinements",
    "label" => "Refinements",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/refinements"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"

  spec.files = Dir["*.gemspec", "lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
end
