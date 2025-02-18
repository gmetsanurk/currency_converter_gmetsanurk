# frozen_string_literal: true

source "https://rubygems.org"

gem 'concurrent-ruby', '1.3.4'
gem "cocoapods"
gem "fastlane"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
