module VagrantPlugins
  module HostManager
    module Resolvers
      def self.default
        proc do |machine|
          ip = nil
          if machine.config.hostmanager.ignore_private_ip != true
            machine.config.vm.networks.each do |network|
              key, options = network[0], network[1]
              ip = options[:ip] if key == :private_network
              break if ip
            end
          end
          ip || (machine.ssh_info ? machine.ssh_info[:host] : nil)
        end
      end

      def self.by_interface(interface = "eth0")
        proc do |machine|
          result  = ""
          command = "ifconfig #{interface} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }'"
          machine.communicate.execute(command) do |type, data|
            result << data if type == :stdout
          end
          result.chomp
        end
      end
    end
  end
end