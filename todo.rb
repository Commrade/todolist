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
		all_tasks << task
	end

	def show
		all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"}
	end

	def write_to_file(filename)
		machinified = @all_tasks.map(&:to_machine).join("\n")
		IO.write(filename, machinified)
	end

	def read_from_file(filename)
		IO.readlines(filename).each do |line|
			status, *description = line.split(':')
			status = status.include?('X')
			add(Task.new(description.join(':').strip, status))
		end
	end

	def delete(task_number)
		all_tasks.delete_at(task_number - 1)
	end

	def update(task_number, task)
		all_tasks[task_number - 1] = task
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
		description
	end

	def completed?
		status
	end

	def to_machine
		"#{represent_status} : #{description}"
	end

	private

	def represent_status
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
			else
				puts 'Sorry, I did not understand that.'
			end
			prompt('Press enter to continue', '')
		end
	puts 'Exited - Thanks for using the Todo List!'
end