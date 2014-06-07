require 'useditor/log'
require 'json'

module Useditor
  # The {Useditor::Workspace} class handles the working storage of the image
  # being manipulated as well as providing the image manipulation functions.
  #
  # @example Creating a default image default 10 x 10 image of color W
  #   image = Useditor::Workspace.new
  #   image.create
  #
  # @example Creating a new empty image with an optional background color
  #   100x100 pixels of color B
  #   image = Useditor::Workspace.new
  #   image.create(rows: 100, cols: 100, color: "B")
  class Workspace

    attr_accessor :image, :rows, :cols, :state_file

    # Creates an instance of the class.  If the workspace file exists it is loaded
    # in order to populate the class state.  if not an empty image is created.
    #
    #  @return [Useditor::Workspace] the new workspace
    def initialize
      @state_file = "./workspace.json"
      get_state
      self
    end

    # Create a new image, deleting any old workspace that might be around
    #
    # @example Creating a default image default 10 x 10 image of color W
    #   image = Useditor::Workspace.new
    #   image.create
    #
    # @example Creating a new empty image with an optional background color
    #   image = Useditor::Workspace.new
    #   image.create(rows: 100, cols: 100, color: "B")
    #
    #  @return [Useditor::Workspace] the new workspace
    def create(rows: 10, cols: 10, color: "B")
      delete_state
      get_state
      @rows = rows
      @cols = cols
      @image = Array.new(rows) do
        Array.new(cols) { color }
      end
      save_state
      self
    end

    # Outputs the current image to the Log
    def log_out
      @image.each do |row|
          Useditor::Log.ok row.join('')
      end
    end

    # Clears the current image setting all pixels to W
    #
    #  @return [Useditor::Workspace] the current workspace
    def clear
      create rows: @rows, cols: @cols, color: "W"
    end

    # Draw a vertical line in col, starting at start_row and ending at end_row
    # in color
    #
    #  @example
    #    image = Useditor::Workspace.new
    #    image.draw_vertical(col: 1, start_row: 5, end_row 8, color: "B")
    #  @return [Useditor::Workspace] the current workspace
    def draw_vertical(col: 0, start_row: 0, end_row: 0, color: "R")
      image.map!.with_index do |row, row_num|
        row.map.with_index do |pixel, col_num|
          if (row_num >= start_row && row_num <= end_row) && (col == col_num)
            color
          else
            pixel
          end
        end
      end
      self
    end

    # Draw a horizontal in row, starting from start_col and ending at end_col
    # in color
    #
    #  @example
    #    image.draw_horizontal(row: 5, start_col: 4, end_col: 10, color: "P")
    #  @return [Useditor::Workspace] the current workspace
    def draw_horizontal(row: 0, start_col: 0, end_col: 0, color: "R")
      image.map!.with_index do |row_array, row_num|
        if row == row_num
          row_array.map.with_index do |pixel, col_num|
            if col_num >= start_col && col_num <= end_col
              color
            else
              pixel
            end
          end
        else
          row_array
        end
      end
      self
    end

    # Set a single pixel to a specific color
    #  @example
    #    image.set_pixel(row: 5, col: 8, color: "B")
    #  @return [Useditor::Workspace] the current workspace
    def set_pixel(row: 0, col: 0, color: "R")
      draw_horizontal(row: row, start_col: col, end_col: col, color: color)
    end

    # Get pixels that are adjacent to the target pixel and are of the same color
    #
    # @example
    #   image.get_region(row: 5, col: 5)
    # @return [Array] Return an array of all pixels in the region
    #   [{row: 1, col: 1}, {row: 1, col: 2}, {row: 2, col: 1}]
    def get_region(row: 0, col: 0)

    end

    # Get all pixels that are adjacent to the target pixel and of the same color
    #
    # @example
    #   image.get_mates(row: 5, col: 5)
    # @return [Array] Return an array of all adjacent pixels of the same color
    #   [{row: 1, col: 1}, {row: 1, col: 2}, {row: 2, col: 1}]
    def get_mates(row: 0, col: 0)
    end

    # Get the color of a single pixle
    #
    # @example
    #   image.get_pixel(row: 5, col: 6, color: "Q")
    #
    # @return [String] The pixel's color
    def get_pixel(row: 0, col: 0, color: "W")
      throw ArgumentError.new("Row out of bounds") if row < 0 || row > @rows
      throw ArgumentError.new("Col out of bounds") if col < 0 || col > @cols

      @image[row][col]
    end

    private



    def get_state
      if File.exists?(@state_file)
        attribs = JSON.parse(File.read(@state_file), symbolize_names: true)
        @image = attribs[:image]
        @rows = attribs[:rows]
        @cols = attribs[:cols]
      else
        @image = []
        @rows = 0
        @cols = 0
      end
    end

    def delete_state
      File.unlink(@state_file) if File.exists?(@state_file)
    end

    def save_state
      File.write(@state_file, JSON.dump({
        image: @image,
        rows: @rows,
        cols: @cols
        }))
    end
  end
end
