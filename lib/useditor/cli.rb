require 'thor'
require 'useditor'
require 'terminal-table'
require 'useditor/log'
require 'useditor/workspace'

# require all configurables
Dir[File.dirname(__FILE__) + "/cli/**/*.rb"].each {|file| require file }

module Useditor
  # Provides a Command Line Interface for the Useditor gem. See the method definitions
  # for more information on its usage.
  #
  # @example Checking the version
  #   useditor version
  class CLI < Thor


    package_name "Useditor"

    def initialize(*args)
      super
    end

    desc "version", "Displays the current version number of Useditor."
    # Displays the current version of the installed Useditor gem on the command line.
    # For more help on this command, use `useditor help version` from the command line.
    def version
      Useditor::Log.info Useditor::VERSION
    end

    desc "print ", "Prints the current image"
    def print
      image = Useditor::Workspace.new
      image.log_out
    end

    desc "create ", "Creates a new image"
    method_option :rows, type: :numeric, alias: "-r", require: true, decs: "Number of rows (height) of the image"
    method_option :cols, type: :numeric, alias: "-c", require: true, decs: "Number of columns (width) of the image"
    def create
      image = Useditor::Workspace.new.create(rows: options[:rows], cols: options[:cols])
    end

    desc "set ", "Sets a single pixel to a color"
    method_option :row, type: :numeric, alias: "-r", require: true, decs: "The row of the pixel to set"
    method_option :col, type: :numeric, alias: "-c", require: true, decs: "The column of the pixel to set"
    method_option :color, type: :string, alias: "-o", require: true, decs: "The color to set the pixel"
    def set
      image = Useditor::Workspace.new
      image.set_pixel(row: options[:row], col: options[:col], color: options[:color])
    end

    desc "clear ", "Clears the current image setting all pixels to W"
    def clear
      image = Useditor::Workspace.new
      image.clear
    end

    desc "vertical ", "Draw a vertical segment"
    method_option :color, type: :string, alias: "-o", require: true, decs: "The color to set the segment"
    method_option :col, type: :numeric, alias: "-c", require: true, decs: "The column in which to draw the segment"
    method_option :start_row, type: :numeric, alias: "-s", require: true, decs: "The start row of the segment"
    method_option :end_row, type: :numeric, alias: "-e", require: true, decs: "The end row of the the segment"
    def vertical
      image = Useditor::Workspace.new
      image.draw_vertical(col: options[:col], start_row: options[:start_row], end_row: options[:end_row], color: options[:color])
    end

    desc "horizontal ", "Draw a horizontal segment"
    method_option :color, type: :string, alias: "-o", require: true, decs: "The color to set the segment"
    method_option :row, type: :numeric, alias: "-r", require: true, decs: "The row in which to draw the segment"
    method_option :start_col, type: :numeric, alias: "-s", require: true, decs: "The start column of the segment"
    method_option :end_col, type: :numeric, alias: "-e", require: true, decs: "The end column of the the segment"
    def horizontal
      image = Useditor::Workspace.new
      image.draw_horizontal(row: options[:row], start_col: options[:start_col], end_col: options[:end_col], color: options[:color])
    end

    desc "fill, ", "Fill a region with a single color"
    method_option :color, type: :string, alias: "-o", require: true, decs: "The color to set the region"
    method_option :row, type: :numeric, alias: "-r", require: true, decs: "The row to select the region"
    method_option :col, type: :numeric, alias: "-c", require: true, decs: "The column to select the region"
    def fill
      image = Useditor::Workspace.new
      image.set_region(row: options[:row], col: options[:col], color: options[:color])
    end

    desc "exe ", "opens a basic shell type input for commands as specified in the test"
    def exe
      @shell_on = true
      command = ""
      while command != "x" do
        puts "Command?"
        input = STDIN.gets
        begin
          input_args = input.downcase.split(' ')
          command = input_args[0]
          case command
          when 's'
            print
          when 'i'
            Useditor::Workspace.new.create(rows: input_args[2].to_i, cols: input_args[1].to_i, color: "O")
          when 'c'
            Useditor::Workspace.new.clear
          when 'l'
            Useditor::Workspace.new.set_pixel(row: input_args[2].to_i - 1 , col: input_args[1].to_i - 1, color: input_args[3].capitalize)
          when 'h'
            Useditor::Workspace.new.draw_horizontal(row: input_args[3].to_i - 1, start_col: input_args[1].to_i - 1, end_col: input_args[2].to_i - 1, color: input_args[4].capitalize)
          when 'v'
            Useditor::Workspace.new.draw_vertical(col: input_args[1].to_i - 1, start_row: input_args[2].to_i - 1, end_row: input_args[3].to_i - 1, color: input_args[4].capitalize)
          when 'f'
            Useditor::Workspace.new.set_region(row: input_args[1].to_i - 1, col:input_args[2].to_i - 1, color: input_args[3].capitalize)
          end
        rescue Exception => e
          Useditor::Log.fatal e
        end
      end
    end


    private

  end
end
