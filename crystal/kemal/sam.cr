#!/bin/crystal

require "./config/*"
require "sam"
require "./db/migrations/*"

load_dependencies "jennifer"

require "./db/seed"

Sam.help

# Here you can define your tasks
# desc "with description to be used by help command"
# task "test" do
#   puts "ping"
# end
