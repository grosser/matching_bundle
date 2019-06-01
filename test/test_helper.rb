# frozen_string_literal: true
require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "maxitest/autorun"
require "maxitest/timeout"
require "mocha/minitest"

require "matching_bundle/version"
require "matching_bundle"
