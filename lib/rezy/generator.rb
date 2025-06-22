require "yaml"
require "erb"
require "fileutils"

module Rezy
  class Generator
    def initialize(data_file: "resume.yaml", template_dir: "template", output_dir: "output", formats: [:html, :pdf])
      @data_file = data_file
      @template_dir = template_dir
      @output_dir = output_dir
      @formats = formats
    end

    def generate
      FileUtils.mkdir_p(@output_dir)

      generate_html if @formats.include?(:html)
      generate_pdf if @formats.include?(:pdf) && playwright_available?
    end
    
    def generate_html
      resume_data = load_data
      html_output = render_template(resume_data)

      File.write(File.join(@output_dir, "resume.html"), html_output)
      FileUtils.cp(File.join(@template_dir, "style.css"), @output_dir)

      puts "\u2705 HTML generated: #{@output_dir}/resume.html"
    end
    
    private
    
    def load_data
      if File.exist?(@data_file)
        YAML.load_file(@data_file)
      else
        raise "Data file not found: #{@data_file}"
      end
    end
    
    def render_template(resume_data)
      template_path = File.join(@template_dir, "template.html.erb")
      template = ERB.new(File.read(template_path))
      result = template.result_with_hash(resume_data: resume_data)
      result.gsub(/\n\s*\n/, "\n").strip.squeeze("\n")
    end
    
    def generate_pdf
      generate_html unless File.exist?(File.join(@output_dir, "resume.html"))
      
      begin
        html_file = File.absolute_path(File.join(@output_dir, 'resume.html'))
        pdf_file = File.join(@output_dir, 'resume.pdf')
        
        # Try using Chrome directly (if available)
        chrome_path = `which google-chrome`.strip
        chrome_path = `which chromium-browser`.strip if chrome_path.empty?
        chrome_path = `which chromium`.strip if chrome_path.empty?
        chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" if chrome_path.empty? && File.exist?("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")

        if !chrome_path.empty? && File.exist?(chrome_path)
          chrome_command = "\"#{chrome_path}\" --headless --disable-gpu --no-margins --run-all-compositor-stages-before-draw --virtual-time-budget=1000 --print-to-pdf=\"#{pdf_file}\" file://#{html_file}"
          success = system(chrome_command)
          if success
            puts "\u2705 PDF generated: #{@output_dir}/resume.pdf"
          else
            puts "⚠️  Chrome PDF generation failed"
          end
        else
          puts "⚠️  Chrome not found - PDF generation skipped"
          puts "   Install Google Chrome or use: brew install --cask google-chrome"
        end
      rescue => e
        puts "⚠️  PDF generation failed: #{e.message}"
      end
    end
    
    def playwright_available?
      # For now, check if Chrome is available instead
      system("test -f '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'")
    end
  end
end
