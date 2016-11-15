# Refinements

[![Gem Version](https://badge.fury.io/rb/refinements.svg)](http://badge.fury.io/rb/refinements)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/refinements.svg)](https://codeclimate.com/github/bkuhlmann/refinements)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/refinements/coverage.svg)](https://codeclimate.com/github/bkuhlmann/refinements)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/refinements.svg)](https://gemnasium.com/bkuhlmann/refinements)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/refinements.svg)](https://travis-ci.org/bkuhlmann/refinements)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

Provides a collection of refinements to core Ruby objects.

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
  - [Requires](#requires)
  - [Using](#using)
  - [Examples](#examples)
    - [String](#string)
    - [Big Decimal](#big-decimal)
    - [Array](#array)
    - [Hash](#hash)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

- Provides Array refinements:
  - `Array#compress` - Removes `nil` and empty values without modifying itself.
  - `Array#compress!` - Removes `nil` and empty values while modifying itself.
- Provides BigDecimal refinements:
  - `BigDecimal#inspect` - Allows one to inspect a big decimal with numeric representation.
- Provides Hash refinements:
  - `#compact` - Removes key/value pairs with `nil` values without modifying itself.
  - `#compact!` - Removes key/value pairs with `nil` values while modifying itself.
  - `#symbolize_keys` - Converts keys to symbols without modifying itself.
  - `#symbolize_keys!` - Converts keys to symbols while modifying itself.
  - `#slice` - Selects hash subset for given keys without modifying itself.
  - `#slice!` - Selects hash subset for given keys while modifying itself.
  - `#deep_merge` - Merges deeply nested hashes together without modifying itself.
  - `#deep_merge!` - Merges deeply nested hashes together while modifying itself.
  - `#reverse_merge` - Merges calling hash into passed in hash without modifying calling hash.
  - `#reverse_merge!` - Merges calling hash into passed in hash while modifying calling hash.
- Provides String refinements:
  - `#blank?` - Answers `true`/`false` based on whether string is blank or not (i.e. `<space>`,
    `\n`, `\t`, `\r`).
  - `#up` - Answers string with only first letter upcased.
  - `#down` - Answers string with only first letter downcased.
  - `#camelcase` - Answers a camelcased string. Example: "ThisIsCamelcase".
  - `#snakecase` - Answers a snakecased string. Example: "this_is_snakecase".
  - `#titleize` - Answers titleized string. Example: "This Is Titleized".

# Requirements

0. [Ruby 2.3.x](https://www.ruby-lang.org).
0. A solid understanding of [Ruby refinements and lexical scope](https://www.youtube.com/watch?v=qXC9Gk4dCEw).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl --location --silent https://www.alchemists.io/gem-public.pem)
    gem install refinements --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification
while allowing the installation of unsigned dependencies since they are beyond the scope of this
gem.

For an insecure install, type the following (not recommended):

    gem install refinements

Add the following to your Gemfile file:

    gem "refinements"

# Usage

## Requires

If all refinements are not desired, add the following to your `Gemfile` instead:

    gem "refinements", require: false

...then require the specific refinement, as needed. Example:

    require "refinements/arrays"
    require "refinements/big_decimals"
    require "refinements/hashes"
    require "refinements/strings"

## Using

Much like including/extending a module, you'll need modify your object(s) to use the refinement(s):

    class Example
      using Refinements::Arrays
      using Refinements::BigDecimals
      using Refinements::Hashes
      using Refinements::Strings
    end

## Examples

The following sections demonstrate how each refinement enriches your objects with new capabilities.

### String

    " \n\t\r".blank? # => true
    "example".up # => "Example"
    "EXAMPLE".down # => "eXAMPLE"
    "this_is_an_example".camelcase # => "ThisIsAnExample"
    "ThisIsAnExample".snakecase # => "this_is_an_example"
    "ThisIsAnExample".titleize # => "This Is An Example"

### Big Decimal

    big = BigDecimal.new "5.0E-10"
    big.inspect # => "#<BigDecimal:3fd3d458fe84 0.0000000005>"

### Array

    example = ["An", nil, "", "Example"]
    example.compress # => ["An", "Example"]
    example # => ["An", nil, "", "Example"]

    example = ["An", nil, "", "Example"]
    example.compress! # => ["An", "Example"]
    example # => ["An", "Example"]

### Hash

    example = {a: 1, b: nil}
    example.compact # => {a: 1}
    example # => {a: 1, b: nil}

    example = {a: 1, b: nil}
    example.compact! # => {a: 1}
    example # => {a: 1}

    example = {"a" => 1, "b" => 2}
    example.symbolize_keys # => {a: 1, b: 2}
    example # => {"a" => 1, "b" => 2}

    example = {"a" => 1, "b" => 2}
    example.symbolize_keys! # => {a: 1, b: 2}
    example # => {a: 1, b: 2}

    example = {a: 1, b: 2, c: 3}
    example.slice :a, :c # => {a: 1, c: 3}
    example # => {a: 1, b: 2, c: 3}

    example = {a: 1, b: 2, c: 3}
    example.slice! :a, :c # => {a: 1, c: 3}
    example # => {a: 1, c: 3}

    example = {a: "A", b: {one: "One", two: "Two"}}
    example.deep_merge b: {one: 1} # => {a: "A", b: {one: 1, two: "Two"}}
    example # => {a: "A", b: {one: "One", two: "Two"}}

    example = {a: "A", b: {one: "One", two: "Two"}}
    example.deep_merge! b: {one: 1} # => {a: "A", b: {one: 1, two: "Two"}}
    example # => {a: "A", b: {one: 1, two: "Two"}}

    example = {a: 1, b: 2}
    example.reverse_merge a: 0, c: 3 # => {a: 1, b: 2, c: 3}
    example # => {a: 1, b: 2}

    example = {a: 1, b: 2}
    example.reverse_merge! a: 0, c: 3 # => {a: 1, b: 2, c: 3}
    example # => {a: 1, b: 2, c: 3}

# Tests

To test, run:

    bundle exec rake

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2015 [Alchemists](https://www.alchemists.io).
Read [LICENSE](LICENSE.md) for details.

# History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at
[Alchemists](https://www.alchemists.io).
