require 'jsonclient'

class BHook
  def initialize(exe, opts, msg)

    @exe = exe
    @opts = opts
    @msg = msg
  end

  def pol(action , msg)

    prot = @exe.unit.conf['pol_prot'] || 'http'
    host = @exe.unit.conf['pol_host'] || 'localhost'
    port = @exe.unit.conf['pol_port'] || '3000'
    path = @exe.unit.conf['pol_path'] || 'pollen'

    uri = "#{prot}://#{host}:#{port}/#{path}/#{msg['exid']}/#{action}"
      # e.g. https://host.org:80/dom-u0-20170514.0383.falibi/returned

    JSONClient.new.put(uri, { message: msg })

    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG
    logger.datetime_format = "%Y-%m-%d %H:%M:%S"

    logger.info("Pollen: #{action} for #{msg['exid']}")
  end
end

class LaunchedPolHook < BHook

  def on(conf, msg)

    pol('launched', msg)

    []
  end
end

class ReturnedPolHook < BHook
  def on(conf, msg)

    pol('returned', msg)

    []
  end
end

class TerminatedPolHook < BHook
  def on(conf, msg)

    pol('terminated', msg)

    []
  end
end

class ErrorPolHook < BHook
  def on(conf, msg)

    pol('error', msg)

    []
  end
end

class CancelPolHook < BHook
  def on(conf, msg)

    pol('cancel', msg)

    []
  end
end
