Pry.config.editor = 'mate'
if defined?(PryDebugger)
  [
    ['c', 'continue'],
    ['s', 'step'],
    ['n', 'next'],
    ['f', 'finish']
  ].each do |shortcut|
    Pry.commands.alias_command shortcut[0], shortcut[1]
  end
end
