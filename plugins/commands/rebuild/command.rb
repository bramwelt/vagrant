require 'optparse'

require "vagrant"

require Vagrant.source_root.join("plugins/commands/up/start_mixins")

module VagrantPlugins
  module CommandRebuild
    class Command < Vagrant.plugin("2", :command)
      # We assume that the `up` and `destroy` plugins exists and they
      # are accessable.
      include VagrantPlugins::CommandDestroy::StartMixins
      include VagrantPlugins::CommandUp::StartMixins

      def self.synopsis
        "rebuilds vagrant machine, as if running `destroy` followed by `up`"
      end

      def execute
        options = {}
        options[:provision_ignore_sentinel] = false

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant rebuild [vm-name]"
          o.separator ""
          build_start_options(o, options)
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        # Validate the provisioners
        validate_provisioner_flags!(options)

        @logger.debug("'rebuild' each target VM...")
        with_target_vms(argv) do |machine|
          machine.action(:rebuild, options)
        end

        # Success, exit status 0
        0
      end
    end
  end
end
