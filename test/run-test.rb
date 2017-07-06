#!/usr/bin/env ruby

require "bundler/setup"

require "test-unit"

require "chupa-text"
ChupaText::Decomposers.load

require_relative "helper"

exit(Test::Unit::AutoRunner.run(true))
