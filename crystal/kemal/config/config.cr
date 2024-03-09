ENV["KEMAL_ENV"] ||= "development"

{% if env("KEMAL_ENV") != "production" %}
  require "dotenv"
  Dotenv.load if File.exists?(File.join(__DIR__, "/../.env"))
{% end %}

require "kemal"
require "uuid"

require "./initializers/*"
require "../src/services/*"
require "../src/models/*"
require "../src/controllers/**"
