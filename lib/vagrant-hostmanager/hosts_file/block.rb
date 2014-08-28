module VagrantPlugins
  module HostManager
    module HostsFile
      class Block

        def initialize(attributes)
          @id = attributes[:id]
          @body = attributes[:body] or raise "body must not be nil"
        end

        # Replace the first occurrence of the block in the supplied content
        # with this version of the block, returning a new string.
        # If the body of the block is empty, remove the block altogether.
        #
        # @return [String] New content with block replaced or removed
        def replace_in(content)
          if @body.empty?
            block = "\n"
          else
            block = "\n\n" + header + @body + footer + "\n"
          end
          # Pattern for finding existing block
          header_pattern = Regexp.quote(header)
          footer_pattern = Regexp.quote(footer)
          pattern = Regexp.new("\n*#{header_pattern}.*?#{footer_pattern}\n*", Regexp::MULTILINE)
          # Replace existing block or append
          content.match(pattern) ? content.sub(pattern, block) : content.rstrip + block
        end

        private

        def header
          id_part = @id ? " id: #{@id}" : ""
          "## vagrant-hostmanager-start#{id_part}\n"
        end

        def footer
          "## vagrant-hostmanager-end\n"
        end
        
      end
    end
  end
end