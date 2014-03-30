module BikeracksHelper
  def admin_user
    # $TODO: add users model & controller and initialize isAdmin properly.
    # For now setting isAdmin to false all the time to prevent unauthenticated
    # users from modifying data
    isAdmin = false

    unless isAdmin?
      respond_to do |format|
        format.html { redirect_to(root_path) }
        format.json { render :json => [], :status => :forbidden }
      end
    end
  end
end
