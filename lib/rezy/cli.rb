require "optparse"

class Rezy::CLI
  def run(argv)
    parse_global_options
  end

  private

  def parse_global_options
    global_parser = OptionParser.new do |opts|
      opts.banner = "Usage: rezy <command> [options]"
      opts.separator ""
      opts.separator "Commands:"
      opts.separator "    init      Initialize a new resume project"
      opts.separator "    generate  Generate resume from existing project"
      opts.separator ""
      opts.on("-v", "--version", "Show version") do
        puts "Rezy #{Rezy::VERSION}"
        exit
      end
      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end

    # Parse global options and get subcommand
    begin
      global_parser.order!
    rescue OptionParser::InvalidOption => e
      puts "Error: #{e.message}"
      puts global_parser
      exit 1
    end

    command = ARGV.shift || "generate"
    case command
    when "init"
      handle_init_command
    when "generate"
      handle_generate_command
    else
      puts "Error: Unknown command '#{command}'"
      puts global_parser
      exit 1
    end
  end

  def handle_init_command
    init_options = {
      template: "simple",
      directory: "."
    }

    OptionParser.new do |opts|
      opts.banner = "Usage: resume init [options]"
      opts.separator ""
      opts.separator "Initialize a new resume project with sample data and template"
      opts.separator ""

      opts.on("-t", "--template NAME", "Template to use (default: simple)") do |template|
        init_options[:template] = template
      end

      opts.on("-d", "--directory DIR", "Directory to create project in (default: current)") do |dir|
        init_options[:directory] = dir
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end.parse!

    init_with_options(init_options)
  end

  def init_with_options(options)
    puts "Initializing resume project with options: #{options.inspect}"
    project_dir = options[:directory]
    mkdir_p(project_dir) unless Dir.exist?(project_dir)

    source_template = File.join(Rezy::TEMPLATES_DIR, options[:template])
    dest_templates_path = File.join(project_dir, "templates")
    FileUtils.cp_r(source_template, dest_templates_path) if Dir.exist?(source_template)

    source_data_file = File.join(Rezy::GEM_ROOT, "data/resume.yaml")
    FileUtils.cp(source_data_file, project_dir) if File.exist?(source_data_file)

    puts "Project initialized with template '#{options[:template]}' in directory '#{project_dir}'"
  rescue => e
    puts "Error initializing project: #{e.message}"
    exit 1
  end

  def handle_generate_command
    # Generate command options (your existing code)
    generate_options = {
      data_file: "resume.yaml",
      output_dir: "output",
      formats: [:html, :pdf]
    }

    OptionParser.new do |opts|
      opts.banner = "Usage: rezy generate [options]"
      opts.separator ""
      opts.separator "Generate resume HTML and PDF from YAML data"
      opts.separator ""

      opts.on("-d", "--data FILE", "YAML data file (default: resume.yaml)") do |file|
        generate_options[:data_file] = file
      end

      opts.on("-o", "--output DIR", "Output directory (default: output)") do |dir|
        generate_options[:output_dir] = dir
      end

      opts.on("-f", "--formats FORMATS", Array, "Output formats: html,pdf (default: html,pdf)") do |formats|
        generate_options[:formats] = formats.map(&:to_sym)
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end.parse!

    generate_with_options(generate_options)
  end

  def generate_with_options(options)
    generator = Rezy::Generator.new(
      data_file: options[:data_file],
      output_dir: options[:output_dir],
      formats: options[:formats]
    )
    generator.generate
  rescue => e
    puts "Error generating resume: #{e.message}"
    exit 1
  end
end
