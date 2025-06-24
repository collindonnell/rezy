# frozen_string_literal: true

source "https://rubygems.org"

gem "nokogiri"
gem "playwright", "~> 0.1.1"
gem "playwright-ruby-client", "~> 1.52"

group :development, :test do
  gem "rake", "~> 13.2"
end

group :development do
  gem "ruby-lsp", "~> 0.24", require: false
  gem "standard", "~> 1.50", require: false
end

group :test do
  gem "minitest", "~> 5.24"
  gem "minitest-difftastic", "~> 0.2.1"
end
