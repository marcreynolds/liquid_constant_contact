require 'benchmark'
require 'json'

module Liquid
  module Tags    
    class ConstantContactBlock < ::Liquid::Block
      
      REDIS_CACHE_SECONDS ||= (30.minutes).seconds
      
      protected
        def redis
          @@redis ||= ::Redis.new
        end
        
        def api
          # puts "retrieving CC API..."
          @api ||= ::ConstantContact::Api.new(api_key)
          # puts "CC API retrieved"
          @api
        end
        
        def campaign
          # puts "retrieving CC Campaign"
          begin
          @campaign ||= api.get_email_campaign(access_token, @campaign_id)
          rescue ::RestClient::ResourceNotFound
            raise ::Liquid::StandardError.new("There was an error retrieving newsletter campaign information.  Please verify the campaign id and try again.")
          end
          # puts "CC Campaign Retrieved"
          @campaign
        end

        def api_key
          # @api_key ||= ENV['cc_api_key']#'qg5g5x7m67phshzwx3fhj9d3'
          @api_key ||= 'qg5g5x7m67phshzwx3fhj9d3'
        end

        def access_token
          # @access_token ||= ENV['cc_access_token']#'02d109fc-48ec-4028-b781-38c9602b4d19'
          @access_token ||= '02d109fc-48ec-4028-b781-38c9602b4d19'
        end
      
    end #ConstantContact
    
    class ConstantContactContactLists < ConstantContactBlock
      
      def render(context)
        context.stack do
          context['lists'] = lists
          render_all(@nodelist, context)
        end
      end
      
      private
      
        def lists
          @lists ||= api.get_lists(access_token).to_json
        end
      
      ::Liquid::Template.register_tag('cc_lists', ConstantContactContactLists)   
    end #ConstantContactContactLists
    
    class ConstantContactCampaigns < ConstantContactBlock
      
      #  usage:
      # 
      #   cc_campaigns sent_to:<list id> limit:<number>
      # 
      
      GROUP_CC_REQUESTS_BY = 10
      
      def initialize(tag_name, markup, tokens, context)
        if markup =~ /starts_with:\'([^\']+)\' limit:([1-9][0-9]*)/
          @starts_with = $1.to_s
          @limit = $2.to_i
        else
          raise ::Liquid::SyntaxError.new("Syntax error in cc_campaigns - Valid syntax: `cc_campaigns starts_with:'<some text>' limit:<number>`, but found #{markup}.")
        end
        
        super
      end
      
      def render(context)
        context.stack do
          context['campaigns'] = campaigns
          render_all(@nodelist, context)
        end
      end
      
      private
      
        def campaigns
          cached = redis.get("campaigns")
          
          return JSON.parse(cached) unless cached.nil?
          
          value = query_for_campaigns
          redis.setex("campaigns", REDIS_CACHE_SECONDS, value.to_json) #30-second expiration              

          value
        end
        
        def query_for_campaigns
          selected = []
          
          campaign_ids = api.get_email_campaigns(access_token, :status => "SENT").results.select{ |x| x.name.start_with?(@starts_with) }.take(5).collect(&:id)
          
          while campaign_id = campaign_ids.shift
            campaign_info = api.get_email_campaign(access_token, campaign_id)
            selected << { "name" => campaign_info.name, "permalink_url" => campaign_info.permalink_url, "json" => campaign_info.to_json }
            # puts "#{selected.count} collected so far."
          end
          
          selected          
        end
      
      ::Liquid::Template.register_tag('cc_campaigns', ConstantContactCampaigns)
    end
    
    # class Campaign < ConstantContactBlock
    #       
    #       Syntax = /(#{::Liquid::QuotedString})+/
    #       def initialize(tag_name, markup, tokens, context)
    #         if markup =~ Syntax
    #           @campaign_id = $1.gsub('\'', '')
    #           puts "parameter_value: #{@campaign_id}"
    #         else
    #           raise ::Liquid::SyntaxError.new("Syntax error in 'cc_campaign' - Valid syntax: `cc_campaign '<campaign_id>'`, but found:`#{markup}`.")
    #         end
    #         super
    #       end
    #     
    #       def render(context)
    #         context['campaign'] = campaign
    #         super
    #       end
    #       
    #     
    #       
    #       
    #       
    #     end #ConstantContactCampaign
    # 
    #     Liquid::Template.register_tag('cc_campaign', Campaign)
    
  end #Tags
  
end #Liquid