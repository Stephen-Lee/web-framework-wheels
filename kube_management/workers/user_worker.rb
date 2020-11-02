class UserWorker
  include SideKiq::Worker

  def perform(user_id)
    p "user: #{user_id}"
  end
end
