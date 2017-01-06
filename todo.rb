# Classes

class List
	attr_reader :all_tasks
	def initialize
		@all_tasks = []
	end

	def add(task)
		all_tasks << task
	end
end

class Task
	attr_reader :description
	def initialize(description)
		@description = description
	end
end

# actions

if __FILE__ == $PROGRAM_NAME
	my_list = List.new
	puts 'You have created a new list'
	my_list.add(Task.new('test'))
	puts 'You have added a task to the Todo List'
end