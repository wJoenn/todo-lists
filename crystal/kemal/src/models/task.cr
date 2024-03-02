class Task < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary32,
    title: String?,
    completed: {type: Bool, default: false},
    created_at: Time?,
    updated_at: Time?,
  )

  validates_presence :title
end
