SERVICES = {}
if settings.development?
  SERVICES = YAML::load(IO.read('config/secrets.yml'))
elsif settings.production?
  SERVICES["slack"]["webhook"] = ENV["SLACK_WEBHOOK"]
  SERVICES["slack"]["token"]   = ENV["SLACK_TOKEN"]
end
