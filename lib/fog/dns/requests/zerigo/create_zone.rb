module Fog
  module Zerigo
    class DNS
      class Real

        require 'fog/dns/parsers/zerigo/create_zone'

        # Create a new zone for Zerigo's DNS servers to serve/host
        # ==== Parameters
        #
        # * domain<~String>
        # * default_ttl<~Integer>
        # * ns_type<~String>
        # * options<~Hash> - optional paramaters
        #   * ns1<~String> - required if ns_type == sec
        #   * nx_ttl<~Integer> -
        #   * slave_nameservers<~String> - required if ns_type == pri
        #   * axfr_ips<~String> - comma-separated list of IPs or IP blocks allowed to perform AXFRs
        #   * custom_nameservers<~String> - comma-separated list of custom nameservers
        #   * custom_ns<~String> - indicates if vanity (custom) nameservers are enabled for this domain
        #   * hostmaster<~String> - email of the DNS administrator or hostmaster
        #   * notes<~String> - notes about the domain
        #   * restrict_axfr<~String> - indicates if AXFR transfers should be restricted to IPs in axfr-ips
        #   * tag_list<~String> - List of all tags associated with this domain
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - zone ID to use for future calls
        #     * 'default-ttl'<~Integer>
        #     * 'nx-ttl'<~Integer>
        #     * 'hosts-count'<~Integer>
        #     * 'created-at'<~String>
        #     * 'custom-nameservers'<~String>
        #     * 'custom-ns'<~String>
        #     * 'domain'<~String>
        #     * 'hostmaster'<~String>
        #     * 'notes'<~String>
        #     * 'ns1'<~String>
        #     * 'ns-type'<~String>
        #     * 'slave-nameservers'<~String>
        #     * 'tag-list'<~String>
        #     * 'updated-at'<~String>
        #     * 'hosts'<~String>
        #     * 'axfr-ips'<~String>
        #     * 'restrict-axfr'<~String>    
        #   * 'status'<~Integer> - 201 if successful        
        
        def create_zone( domain, default_ttl, ns_type, options = {})

          optional_tags= ''
          options.each { |option, value|
            case option
            when :ns1
              optional_tags+= "<ns1>#{value}</ns1>"
            when :nx_ttl
              optional_tags+= "<nx-ttl type='interger'>#{value}</nx-ttl>"
            when :slave_nameservers
              optional_tags+= "<slave-nameservers>#{value}</slave-nameservers>"
            when :axfr_ips
              optional_tags+= "<axfr-ips>#{value}</axfr-ips>"
            when :custom_nameservers
              optional_tags+= "<custom-nameservers>#{value}</custom-nameservers>"
            when :custom_ns
              optional_tags+= "<custom-ns>#{value}</custom-ns>"
            when :hostmaster
              optional_tags+= "<hostmaster>#{value}</hostmaster>"
            when :notes
              optional_tags+= "<notes>#{value}</notes>"
            when :restrict_axfr
              optional_tags+= "<restrict-axfr>#{value}</restrict-axfr>"
            when :tag_list
              optional_tags+= "<tag-list>#{value}</tag-list>"
            end
          }
          
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><zone><domain>#{domain}</domain><default-ttl type="integer">#{default_ttl}</default-ttl><ns-type>#{ns_type}</ns-type>#{optional_tags}</zone>},
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::Zerigo::DNS::CreateZone.new,
            :path     => '/api/1.1/zones.xml'
          )
        end

      end

      class Mock

        def create_zone(domain, default_ttl, ns_type, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
