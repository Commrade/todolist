# Modules

module Menu
	def menu
		"Welcome to the Todo List Program!
		The following menu will help you use the program:
		1) Add
		2) Show
		3) Write to a File
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
		all_tasks
	end

	def write_to_file(filename)
		IO.write(filename, @all_tasks.map(&:to_s).join("\n"))
	end
end

class Task
	attr_reader :description
	def initialize(description)
		@description = description
	end

	def to_s
		description
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
			when '3'
				my_list.write_to_file(prompt('What is the file to write to?'))
			else
				puts 'Sorry, I did not understand that.'
			end
			prompt('Press enter to continue', '')
		end
	puts 'Exited - Thanks for using the Todo List!'
end