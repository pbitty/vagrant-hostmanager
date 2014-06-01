module VagrantPlugins
  module HostManager
    module HostsFile
      module Resolvers

        def self.dhcp(interface_name = "eth0")
          if interface_name.to_s.empty?
            raise "Interface name cannot be blank"
          end

          command = "LANG=en ifconfig #{interface_name.to_s} | grep 'inet addr:'| cut -d: -f2 | awk '{ print $1 }'"

          return proc do |machine, resolving_machine|
            result  = ""
            machine.communicate.execute(command) do |type, data|
              result << data if type == :stdout
            end
            result.chomp
          end
        end

      end
    end
  end
end
