ENV["KEMAL_ENV"] ||= "development"

{% if env("KEMAL_ENV") != "production" %}
  require "dotenv"
  Dotenv.load
{% end %}

require "kemal"
require "uuid"

require "./initializers/*"
require "../src/services/*"
require "../src/models/*"
require "../src/controllers/*"
