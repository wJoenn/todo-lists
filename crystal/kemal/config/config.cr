ENV["KEMAL_ENV"] ||= "development"

{% if env("KEMAL_ENV") != "production" %}
  require "dotenv"
  Dotenv.load
{% end %}

require "./initializers/**"
require "../src/models/*"
