require_relative "rezy/version"
require_relative "rezy/generator"
require_relative "rezy/cli"

module Rezy
  class Error < StandardError; end
  GEM_ROOT = File.expand_path("..", __dir__)
  TEMPLATES_DIR = File.join(GEM_ROOT, "templates")
end
