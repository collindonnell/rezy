require_relative "test_helper"
require "nokogiri"

class Resume::GeneratorTest < Minitest::Test
  def setup
    @test_output_dir = "tmp/test_output"
    @generator = Resume::Generator.new(
      data_file: "test/fixtures/resume.yaml",
      output_dir: @test_output_dir
    )
    FileUtils.mkdir_p(@test_output_dir)
  end

  def teardown
    FileUtils.rm_rf(@test_output_dir)
  end

  def test_generate_creates_files
    @generator.generate
    
    assert File.exist?("#{@test_output_dir}/resume.html")
    assert File.exist?("#{@test_output_dir}/style.css")
  end

  def test_html_structure
    @generator.generate
    html = File.read("#{@test_output_dir}/resume.html")
    doc = Nokogiri::HTML(html)
    
    # Basic HTML structure
    assert doc.css('html').any?, "Missing <html> element"
    assert doc.css('head').any?, "Missing <head> element"
    assert doc.css('body').any?, "Missing <body> element"
    
    # CSS link
    assert doc.css('link[rel="stylesheet"]').any?, "Missing CSS link"
  end

  def test_header_content
    @generator.generate
    html = File.read("#{@test_output_dir}/resume.html")
    doc = Nokogiri::HTML(html)
    
    # Name in h1
    h1 = doc.css('h1').first
    assert h1, "Missing h1 element"
    assert_includes h1.text, "Johnny Appleseed"
    
    # Contact info
    header = doc.css('header').first
    assert header, "Missing header element"
    assert_includes header.text, "Portland, OR"
    assert_includes header.text, "johnny.appleseed@icloud.com"
    assert_includes header.text, "555-555-5555"
  end

  def test_summary_section
    @generator.generate
    html = File.read("#{@test_output_dir}/resume.html")
    doc = Nokogiri::HTML(html)
    
    # Summary section exists
    summary_section = doc.css('section').find { |s| s.css('h2').text.include?("Summary") }
    assert summary_section, "Missing summary section"
    
    # Summary content
    assert_includes summary_section.text, "code gardener"
  end

  def test_skills_table
    @generator.generate
    html = File.read("#{@test_output_dir}/resume.html")
    doc = Nokogiri::HTML(html)
    
    # Skills table exists
    skills_table = doc.css('table.skills-table').first
    assert skills_table, "Missing skills table"
    
    # Check for skill categories
    table_text = skills_table.text
    assert_includes table_text, "Languages"
    assert_includes table_text, "Frameworks"
    assert_includes table_text, "Soft Skills"
    
    # Check for specific skills
    assert_includes table_text, "Swift"
    assert_includes table_text, "Ruby"
    assert_includes table_text, "UIKit"
  end

  def test_experience_section
    @generator.generate
    html = File.read("#{@test_output_dir}/resume.html")
    doc = Nokogiri::HTML(html)
    
    # Experience section header
    experience_h2 = doc.css('h2').find { |h| h.text.include?("Experience") }
    assert experience_h2, "Missing Experience h2"
    
    # Experience entries
    experience_headers = doc.css('.experience-header')
    assert experience_headers.length >= 2, "Should have at least 2 experience entries"
    
    # Check for specific companies
    all_text = doc.text
    assert_includes all_text, "Acme Inc."
    assert_includes all_text, "Test Engineer"
    assert_includes all_text, "Lumen Technologies"
    assert_includes all_text, "Macrodata Refinery Engineer"
    
    # Check for dates
    assert_includes all_text, "2022"
    assert_includes all_text, "Present"
    assert_includes all_text, "2020"
    
    # Check for bullet points
    bullets = doc.css('ul li')
    assert bullets.length >= 4, "Should have multiple bullet points"
    
    bullet_text = bullets.map(&:text).join(" ")
    assert_includes bullet_text, "high-performance applications"
    assert_includes bullet_text, "macrodata processes"
  end

  def test_no_missing_data
    @generator.generate
    html = File.read("#{@test_output_dir}/resume.html")
    
    # Should not contain common ERB error indicators
    refute_includes html, "nil"
    refute_includes html, "undefined"
    refute_includes html, "<%"
    refute_includes html, "%>"
    
    # Should not have excessive blank lines
    lines = html.lines
    blank_lines = lines.count { |line| line.strip.empty? }
    total_lines = lines.count
    
    assert (blank_lines.to_f / total_lines) < 0.3, "Too many blank lines in output"
  end

  def teardown
    FileUtils.rm_rf(@test_output_dir) if Dir.exist?(@test_output_dir)
  end
end