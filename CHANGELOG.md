# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Security

- Fixed out-of-bounds string access vulnerability in parser that caused crashes when processing malformed input with trailing backslash
- Added `max_bytes` option to `JSONC.parse` and `JSONC.load_file` methods to prevent memory exhaustion DoS attacks (default: 10MB)

## [0.1.0] - 2025-08-24

### Added

- Initial release

[unreleased]: https://github.com/ytkg/jsonc/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/ytkg/jsonc/releases/tag/v0.1.0
