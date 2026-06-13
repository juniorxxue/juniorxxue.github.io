# frozen_string_literal: true

source "https://rubygems.org"

# Use the github-pages gem so local builds match exactly what GitHub Pages runs
# in production (same Jekyll version + supported plugin set).
# Versions: https://pages.github.com/versions/
gem "github-pages", group: :jekyll_plugins

# Local preview server (needed on Ruby 3+; not bundled by default).
gem "webrick", "~> 1.8"

# Windows and JRuby do not include zoneinfo files, so bundle tzinfo-data.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end
