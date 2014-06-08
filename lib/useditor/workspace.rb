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
      create rows: @rows, cols: @cols, color: "O"
      save_state
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
      save_state
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
      save_state
      self
    end

    # Set a single pixel to a specific color
    #  @example
    #    image.set_pixel(row: 5, col: 8, color: "B")
    #  @return [Useditor::Workspace] the current workspace
    def set_pixel(row: 0, col: 0, color: "R")
      draw_horizontal(row: row, start_col: col, end_col: col, color: color)
      save_state
      self
    end

    # Get pixels that are adjacent to the target pixel and are of the same color
    #
    # @example
    #   image.get_region(row: 5, col: 5)
    # @return [Array] Return an array of all pixels in the region
    #   [{row: 1, col: 1}, {row: 1, col: 2}, {row: 2, col: 1}]
    def get_region(row: 0, col: 0, region: [])
      # add the current pixel
      region << {row: row, col: col}
      # Get all his mates
      mates = get_mates(row: row, col: col)
      # add in any mates that are not already there
      mates.each do |mate|
        if !region.include?(mate)
          get_region(row: mate[:row], col: mate[:col], region: region).each do |pixel|
            region << pixel if !region.include?(pixel)
          end
        end
      end
      region
    end

    # Sets all the pixels of a region to a color
    #
    # @example
    #   image.set_region(row: 1, col: 1, color: "X")
    # @return [Useditor::Workspace] the current workspace
    def set_region(row: 0, col: 0, color: "K")
      raise Useditor::Workspace::PixelLocationError.new("Row out of bounds") if row < 0 || row > (@rows -1)
      raise Useditor::Workspace::PixelLocationError.new("Col out of bounds") if col < 0 || col > (@cols -1)

      region = get_region(row: row, col: col)
      region.each do |pixel|
        set_pixel(row: pixel[:row], col: pixel[:col], color: color)
      end
      save_state
      self
    end

    # Get all pixels that are adjacent to the target pixel and of the same color
    #
    # @example
    #   image.get_mates(row: 5, col: 5)
    # @return [Array] Return an array of all adjacent pixels of the same color
    #   [{row: 1, col: 1}, {row: 1, col: 2}, {row: 2, col: 1}]
    def get_mates(row: 0, col: 0)
      color = get_pixel(row: row, col: col)
      mates = []
      [row -1, row, row + 1].each do |row_num|
        [col -1, col, col + 1].each do |col_num|
          begin
            if (row_num == row && col_num == col)
              # Skip this as it is our target pixel
            else
              # This is a canidate for a mate so check color
              if color == get_pixel(row: row_num, col: col_num)
                mate = {row: row_num, col: col_num}
                if !mates.include? mate
                  mates << mate
                end
              end
            end
          rescue Useditor::Workspace::PixelLocationError => e
          end
        end
      end
      mates
    end

    # Get the color of a single pixle
    #
    # @example
    #   image.get_pixel(row: 5, col: 6, color: "Q")
    #
    # @return [String] The pixel's color
    def get_pixel(row: 0, col: 0, color: "W")
      raise Useditor::Workspace::PixelLocationError.new("Row out of bounds") if row < 0 || row > (@rows -1)
      raise Useditor::Workspace::PixelLocationError.new("Col out of bounds") if col < 0 || col > (@cols -1)
      @image[row][col]
    end

    # Exception representing pixel row or col out of range
    class PixelLocationError < ArgumentError
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
