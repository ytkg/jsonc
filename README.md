# JSONC

[![Gem Version](https://badge.fury.io/rb/jsonc.svg)](https://badge.fury.io/rb/jsonc)

A simple Ruby gem to parse JSON with Comments (JSONC) and trailing commas.

This gem provides `JSONC.parse` and `JSONC.load_file` methods that act as drop-in replacements for the standard `JSON` library, with added support for modern JSON extensions.

## Features

- **Comments**: Parses JSON with `//` single-line and `/* */` multi-line comments.
- **Trailing Commas**: Parses JSON with trailing commas in objects and arrays.
- **Standard Interface**: Forwards all options (e.g., `symbolize_names`) to the standard `JSON.parse` method.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add jsonc
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install jsonc
```

## Usage

### Parsing a String

Use `JSONC.parse` in place of `JSON.parse`.

```ruby
require 'jsonc'

jsonc_string = <<-JSONC
{
  // The name of the user
  "name": "Jules",
  /*
    The user's role.
    Can be "agent" or "user".
  */
  "role": "agent", // Trailing commas are allowed!
}
JSONC

parsed_hash = JSONC.parse(jsonc_string)
# => { "name" => "Jules", "role" => "agent" }

puts parsed_hash["name"]
# => Jules
```

#### Size Limit

To prevent memory exhaustion from malicious or excessively large inputs, you can set a `max_bytes` limit (default: 10MB):

```ruby
# Default 10MB limit
JSONC.parse(jsonc_string)

# Custom size limit (50MB)
JSONC.parse(large_jsonc_string, max_bytes: 52_428_800)

# Also works with load_file
JSONC.load_file('config.jsonc', max_bytes: 1_048_576)  # 1MB
```

Exceeding the size limit raises a `JSON::ParserError`.

### Loading a File

Use `JSONC.load_file` in place of `JSON.load_file`.

```ruby
# Given a file named 'config.jsonc' with the content from above:

require 'jsonc'

parsed_hash = JSONC.load_file('config.jsonc', symbolize_names: true)
# => { name: "Jules", role: "agent" }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ytkg/jsonc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ytkg/jsonc/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JSONC project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ytkg/jsonc/blob/main/CODE_OF_CONDUCT.md).
