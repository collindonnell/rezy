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

By default, this will use the simple template included with the gem. You can specify a custom template with:

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/collindonnell/rezy.

## License

The gem is available as open source under the terms of the MIT License.