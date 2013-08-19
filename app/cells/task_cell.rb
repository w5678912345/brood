class TaskCell < Cell::Rails

  def sup
  	@tasks = Task.sup_scope
    render
  end

end
