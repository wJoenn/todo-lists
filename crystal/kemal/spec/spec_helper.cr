ENV["KEMAL_ENV"] = "test"

require "spec"
require "../src/app.cr"

Jennifer::Migration::Runner.migrate

Spec.before_each do
  Jennifer::Adapter.default_adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.default_adapter.rollback_transaction
end
