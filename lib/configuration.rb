

def require_config name
  require File.expand_path(
    File.dirname(__FILE__) + "/../config/" + name)
end

require_config 'database'