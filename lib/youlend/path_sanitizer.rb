# frozen_string_literal: true

module Youlend
  class PathSanitizer
    # Removes any leading '/' and guarantees an ending '/'
    def self.sanitize(path)
      parts = path.split('/').reject(&:empty?)
      new_path = parts.join('/')

      [new_path, '/'].join
    end
  end
end
