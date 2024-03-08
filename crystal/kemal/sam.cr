#!/bin/crystal

require "./config/*"
require "sam"
require "./db/migrations/*"
require "./db/seed"

load_dependencies "jennifer"

desc "generate a hex64 secret key"
task "secret" do
  puts Random::Secure.hex(64)
end

Sam.help
