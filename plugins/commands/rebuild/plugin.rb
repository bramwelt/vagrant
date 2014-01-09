require "vagrant"

module VagrantPlugins
  module CommandRebuild
    class Plugin < Vagrant.plugin("2")
      name "rebuild command"
      description <<-DESC
      The `rebuild` command will destroy your machine, and bring it back up.
      DESC

      command("rebuild") do
        require File.expand_path("../command", __FILE__)
        Command
      end
    end
  end
end
