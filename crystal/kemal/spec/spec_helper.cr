ENV["KEMAL_ENV"] = "test"
ENV["PORT"] = "9999"

require "spec-kemal"
require "../src/app.cr"

require "../db/migrations/*"
Jennifer::Migration::Runner.migrate

Spec.before_each do
  Jennifer::Adapter.default_adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.default_adapter.rollback_transaction
end
