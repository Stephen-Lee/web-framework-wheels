class UsersController
  def show
    UserWorker.perform_async(102)
    'show user'
  end
end