# Refinements

[![Gem Version](https://badge.fury.io/rb/refinements.svg)](http://badge.fury.io/rb/refinements)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/refinements.svg)](https://codeclimate.com/github/bkuhlmann/refinements)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/refinements/coverage.svg)](https://codeclimate.com/github/bkuhlmann/refinements)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/refinements.svg)](https://gemnasium.com/bkuhlmann/refinements)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/refinements.svg)](http://travis-ci.org/bkuhlmann/refinements)

Provides a collection of refinements to the standard Ruby objects.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
    - [Array](#array)
    - [Big Decimal](#big-decimal)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Features

- Adds the following Array refinements:
    - Array#compress - Removes nil and empty values without modifying original values.
    - Array#compress! - Removes nil and empty values and modifies original values.
- Adds the following BigDecimal refinements:
    - BigDecimal#inspect - Allows one to inspect a big decimal with numeric representation.

# Requirements

0. [MRI 2.x.x](http://www.ruby-lang.org).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl -Ls http://www.my-website.com/gem-public.pem)
    gem install refinements --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install refinements

# Usage

## Array

    using Refinements::ArrayExtensions

    example = ["An", nil, "", "Example"]
    example.compress # => ["An", "Example"]
    example # => ["An", nil, "", "Example"]

    example = ["An", nil, "", "Example"]
    example.compress! # => ["An", "Example"]
    example # => ["An", "Example"]

## Big Decimal

    using Refinements::BigDecimalExtensions

    big = BigDecimal.new "5.0E-10"
    big.inspect # => "#<BigDecimal:3fd3d458fe84 0.0000000005>"

# Tests

To test, run:

    bundle exec rspec spec

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
