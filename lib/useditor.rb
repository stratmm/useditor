require "useditor/version"

# The {Useditor} module provides a mix of helper classes to provide the
# the image editing functionality
module Useditor

  # Determine the path to where this gem currently resides on the host filesystem
  #
  # @return [String] the filepath to where this gem is located.
  def self.root
    Gem::Specification.find_by_name("useditor").gem_dir
  end

end
