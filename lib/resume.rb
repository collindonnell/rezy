require_relative "resume/version"
require_relative "resume/generator"
require_relative "resume/cli"

module Resume
  class Error < StandardError; end
  GEM_ROOT = File.expand_path("..", __dir__)
  TEMPLATES_DIR = File.join(GEM_ROOT, "templates")
end