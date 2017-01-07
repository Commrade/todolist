# Modules

module Menu
	def menu
		"Welcome to the Todo List Program!
		The following menu will help you use the program:
		1) Add
		2) Update
		3) Delete
		4) Show
		5) Write to a File
		6) Read from a File
		7) Completed Status
		Q) Quit "
	end

	def show
		menu
	end
end

module Promptable
	def prompt(message = 'What would you like to do?', symbol = ':> ')
		print message
		print symbol
		gets.chomp
	end
end

# Classes

class List
	attr_reader :all_tasks
	def initialize
		@all_tasks = []
	end

	def add(task)
		# Adds tasks to all_tasks array
		all_tasks << task
	end

	def show
		# Shows all tasks and applies a number index
		all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"}
	end

	def write_to_file(filename)
		# Writes all_tasks to a file the user names
		# Applies a task method to mark complete or incomplete status first
		machinified = @all_tasks.map(&:to_machine).join("\n")
		IO.write(filename, machinified)
	end

	def read_from_file(filename)
		# Takes all items from a file and applies them to current all_tasks list
		# Detects if the file originated from program with complete and incomplete status'
		IO.readlines(filename).each do |line|
			status, *description = line.split(':')
			status = status.include?('X')
			add(Task.new(description.join(':').strip, status))
		end
	end

	def delete(task_number)
		# Deletes the task from all_tasks
		all_tasks.delete_at(task_number - 1)
	end

	def update(task_number, task)
		# Update/replace task at specific location with new task listed by user
		all_tasks[task_number - 1] = task
	end

	def toggle(task_number)
		# Toggles specified item in all_tasks as completed or incompleted
		all_tasks[task_number - 1].toggle_status
		puts "Toggle complete task: #{all_tasks[task_number - 1].to_s}"
	end
end

class Task
	attr_reader :description
	attr_accessor :status
	def initialize(description, status = false)
		@description = description
		@status = false
	end

	def to_s
		# Converts description to a string
		description
	end

	def completed?
		# Gives a tasks status complete or incomplete
		status
	end

	def to_machine
		# Applies a check box in addition to the task description
		"#{represent_status} : #{description}"
	end

	def toggle_status
		# Switches a tasks complete or incomplete status
		@completed_status = !completed?
	end

	private

	def represent_status
		# Used to create a complete or incomplete check box
		"#{completed? ? '[X]' : '[ ]'}"
	end
end

# actions

if __FILE__ == $PROGRAM_NAME
	include Menu
	include Promptable
	my_list = List.new
	puts 'Please choose from the following list.'
		until ['q'].include?(user_input = prompt(show).downcase)
			case user_input
			when '1'
				my_list.add(Task.new(prompt('What is the task you would like to add?')))
			when '2'
				puts my_list.show
				my_list.update(prompt('What task would you like to edit?').to_i, Task.new(prompt('Enter new task ')))
			when '3'
				puts my_list.show
				my_list.delete(prompt('What task would you like to remove?').to_i)
			when '4'
				puts my_list.show
			when '5'
				my_list.write_to_file(prompt('What is the filename to write to?'))
			when '6'
				begin
					my_list.read_from_file(prompt('What is the filename to read from?'))
				rescue Errno::ENOENT
					puts 'Filename not found, please verify your filename and path.'
				end
			when '7'
				puts my_list.show
				my_list.toggle(prompt('Which task would you like to toggle the status for?').to_i)
			else
				puts 'Sorry, I did not understand that.'
			end
			prompt('Press enter to continue', '')
		end
	puts 'Exited - Thanks for using the Todo List!'
end