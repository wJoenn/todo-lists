#!/bin/crystal

require "./config/*"
require "sam"
require "./db/migrations/*"

load_dependencies "jennifer"

require "./db/seed"

desc "generate a hex64 secret key"
task "secret" do
  puts Random::Secure.hex(64)
end

Sam.help
