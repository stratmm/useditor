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
    #   100x100 pixels of color B
    #   image = Useditor::Workspace.create(rows: 100, cols: 100, color: B)
    def create(rows: 10, cols: 10, color: "B")
      delete_state
      get_state
      @rows = rows
      @cols = cols
      @image = Array.new(rows) do
        Array.new(cols) { color }
      end
      self
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
