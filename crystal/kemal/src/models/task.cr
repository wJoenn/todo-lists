class Task < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary32,
    title: String?,
    completed: {type: Bool, default: false},
    user_id: Int32?,
    created_at: Time?,
    updated_at: Time?,
  )

  belongs_to :user, User

  validates_presence :title
  validates_presence :user_id
end
