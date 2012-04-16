ENV['RACK_ENV'] = 'test'
require './app'
Bundler.require :test

require 'rspec'
require 'capybara/dsl'
include Capybara::DSL
Capybara.app = FormulasApp
