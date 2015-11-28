# Refinements

[![Gem Version](https://badge.fury.io/rb/refinements.svg)](http://badge.fury.io/rb/refinements)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/refinements.svg)](https://codeclimate.com/github/bkuhlmann/refinements)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/refinements/coverage.svg)](https://codeclimate.com/github/bkuhlmann/refinements)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/refinements.svg)](https://gemnasium.com/bkuhlmann/refinements)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/refinements.svg)](http://travis-ci.org/bkuhlmann/refinements)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

Provides a collection of refinements for core Ruby objects.

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
  - [Requires](#requires)
  - [Using](#using)
  - [Examples](#examples)
    - [Array](#array)
    - [Big Decimal](#big-decimal)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

- Adds Array refinements:
    - `Array#compress` - Removes nil and empty values without modifying original values.
    - `Array#compress!` - Removes nil and empty values and modifies original values.
- Adds BigDecimal refinements:
    - `BigDecimal#inspect` - Allows one to inspect a big decimal with numeric representation.

# Requirements

0. [MRI 2.x.x](http://www.ruby-lang.org).
0. A solid understanding of [Ruby refinements and lexical scope](https://www.youtube.com/watch?v=qXC9Gk4dCEw).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl -Ls http://www.my-website.com/gem-public.pem)
    gem install refinements --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install refinements

Add the following to your Gemfile file:

    gem "refinements"

# Usage

## Requires

Due to this gem being a collection of Ruby refinements, none of the refinements are auto-loaded by default in order to
reduce code bloat for your app. Instead, require the specific requirement for the code that needs it. You'll want to
require one or all of the following:

    require "refinements/array_extensions"
    require "refinements/big_decimal_extensions"

## Using

In addition to requiring the appropriate refinement file for the code that needs it, you'll also need to use the
refinement by using the `using` keyword within your object. You'll want to use one or all of the following:

    class Example
      using Refinements::ArrayExtensions
      using Refinements::BigDecimalExtensions
    end

## Examples

With the appropriate refinements required and used within your objects, the following sections demonstrates how each
refinement enriches your objects with new capabilities.

### Array

    example = ["An", nil, "", "Example"]
    example.compress # => ["An", "Example"]
    example # => ["An", nil, "", "Example"]

    example = ["An", nil, "", "Example"]
    example.compress! # => ["An", "Example"]
    example # => ["An", "Example"]

### Big Decimal

    big = BigDecimal.new "5.0E-10"
    big.inspect # => "#<BigDecimal:3fd3d458fe84 0.0000000005>"

# Tests

To test, run:

    bundle exec rake

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible public API enhancements and/or bug fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2015 [Alchemists](https://www.alchemists.io).
Read the [LICENSE](LICENSE.md) for details.

# History

Read the [CHANGELOG](CHANGELOG.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at [Alchemists](https://www.alchemists.io).
