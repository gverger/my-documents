class Command
  RunError = Class.new(StandardError)

  attr_reader :runner, :command

  def initialize(command, options = {})
    @runner = TTY::Command.new(default_options.merge(options))
    @command = command
  end

  def output
    run.out
  end

  def error
    run.err
  end

  def run
    @run ||= runner.run(command)
  rescue TTY::Command::ExitError => e
    raise RunError, e.message
  end

  def default_options
    { printer: :null, timeout: 4.hours }
  end
end
