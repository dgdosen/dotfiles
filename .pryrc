# require 'amazing_print'
#
# AmazingPrint.pry!

# Alias commands for debugging convenience
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

# Alias 'q' for 'exit-all' to quickly exit the console
Pry.config.commands.alias_command 'q', 'exit-all'

# Suppress return values to keep the console clean.
Pry.config.print = proc {}
