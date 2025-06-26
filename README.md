# Rezy

A simple Ruby gem for generating resumes from YAML data files using customizable templates.

## Installation

```
$ gem install rezy
```

## Usage

1. Create a new resume project directory and use `rezy init` to populate resume data
2. Update YAML file with your resume data (`data/resume.yaml`)
3. Update the template ERB and CSS however you like (`template` directory)
4. Generate your resume:

```
$ rezy generate
```

## YAML Data Format
The resume data should be structured as a YAML file with the following format:

```yaml
name: Your Full Name
contact_info:
  - email@example.com
  - phone-number
  - City, State
summary: Brief professional summary or objective statement
skills:
  Category Name:
    - Skill 1
    - Skill 2
  Another Category:
    - Tool 1
    - Tool 2
experience:
  - company: Company Name
    role: Job Title
    location: Remote
    start: "Start Year"
    end: "End Year or Present"
    bullets:
      - Achievement or responsibility
      - Another accomplishment
```

The `contact_info` section accepts a list of contact details in any order. 

Skills are organized by category (e.g., "Languages", "Frameworks", "Tools") with each category containing a list of relevant skills. 

Experience entries include company, role, location, date range, and bullet points describing responsibilities and achievements. Values for `start` and `end` can be any string, e.g. a year, "Present", etc.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/collindonnell/rezy.

## License

The gem is available as open source under the terms of the MIT License.
