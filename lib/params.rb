require 'uri'
require 'active_support/inflector'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @route_params = route_params
      @query_string = parse_www_encoded_form(@req.query_string)
      @body = parse_www_encoded_form(@req.body)
      @body ||= {}
      @query_string ||= {}

    end

    def [](key)
      @params = @body.merge(@query_string.merge(@route_params))
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      results = {}
      if www_encoded_form
        nested_hash = {}
        URI::decode_www_form(www_encoded_form).each do |pair|
          keys = parse_key(pair.first)
          current_value = pair.last
          until keys.empty?
            nested_hash[keys.pop] = current_value
            current_value = nested_hash
          end
        end
        results.deep_merge!(nested_hash)
      end
      results
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key_array = key.split("[")
      key_array.each_with_index do |key, i|
        if i > 0
          key.chop!
        end
      end
      key_array
    end
  end
end
