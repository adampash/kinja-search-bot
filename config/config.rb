if !settings.nil? and settings.development?
  SERVICES = YAML::load(IO.read('config/secrets.yml'))
else
  SERVICES = {}
  SERVICES["slack"]["webhook"] = ENV["SLACK_WEBHOOK"]
  SERVICES["slack"]["token"]   = ENV["SLACK_TOKEN"]
end
