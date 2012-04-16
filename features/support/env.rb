ENV['RACK_ENV'] = 'test'
require './app'
Bundler.require :test

require 'capybara/cucumber'
require 'capybara/dsl'
Capybara.app = FormulasApp
Capybara.javascript_driver = :webkit


