module SlideShare
  class Slideshows
    attr_accessor :base
    
    # This method should only be called internally from an instance of
    # <tt>SlideShare::Base</tt>.
    def initialize(base) # :nodoc:
      self.base = base
    end
    
    # Returns id of newly created slideshow if successful or raises an appropriate
    # exception if not. Takes the following options:
    # 
    # * <tt>:slideshow_description</tt> - Description for the slideshow
    # * <tt>:slideshow_tags</tt> - Tags for the slideshow. Multiple tags should be separated
    #   by spaces, using quotes to create individual multiple word tags.
    # * <tt>:make_src_public</tt> - Set to <tt>true/false</tt> to allow users to download
    #   the slideshow
    # * <tt>:make_slideshow_private</tt> - Set to <tt>true/false</tt> to change the privacy
    #   setting appropriately
    # 
    # The following options will only be used if <tt>:make_slideshow_private</tt> is set
    # <tt>true</tt>:
    # 
    # * <tt>:generate_secret_url</tt> - Set to <tt>true/false</tt> to generate a secret URL
    # * <tt>:allow_embeds</tt> - Set to <tt>true/false</tt> to allow websites to embed
    #   the private slideshow
    # * <tt>:share_with_contacts</tt> - Set to <tt>true/false</tt> to allow your contacts to
    #   view the private slideshow
    def create(title, filename, username, password, options = {})
      force_boolean_params_to_letters! options
      options.merge!(:username => username, :password => password,
        :slideshow_title => title)
      params = base.send(:add_required_params, options).map do |key, value|
        Curl::PostField.content(key.to_s, value)
      end
      params << Curl::PostField.file("slideshow_srcfile", File.expand_path(filename))
      
      curl = Curl::Easy.new("#{SlideShare::Base.base_uri}/upload_slideshow") do |c|
        c.multipart_form_post = true
      end
      curl.http_post(*params)
      
      body = ToHashParser.from_xml(curl.body_str)
      response = base.send(:catch_errors, body)
      # I'd presume the id returned was an integer
      response["SlideShowUploaded"]["SlideShowID"].to_i
    end
    
    # Returns hash of attributes for slideshow if successful or raises an appropriate
    # exception if not. Takes the following options:
    # 
    # * <tt>:username</tt> - SlideShare username of the user _making_ the request
    # * <tt>:password</tt> - SlideShare password of the user _making_ the request
    # * <tt>:detailed</tt> - Set to <tt>true</tt> to return additional, detailed information
    #   about the slideshow (see the official API documentation here[http://www.slideshare.net/developers/documentation]
    #   for more information). Default is <tt>false</tt>.
    def find(id, options = {})
      detailed = convert_to_number(options.delete(:detailed))
      options[:detailed] = detailed unless detailed.nil?
      base.send :get, "/get_slideshow", options.merge(:slideshow_id => id)
    end
    
    # Returns hash representing the user requests and an array of their slideshows
    # Takes the following options.
    #
    # * <tt>:username</tt> - Slideshare username of the user
    # * <tt>:password</tt> - SlideShare password of the user _making_ the request
    # * <tt>:detailed</tt> - Set to <tt>true</tt> to return additional, detailed information
    def find_all_by_user(user, options = {})
      detailed = convert_to_number(options.delete(:detailed))
      options[:detailed] = detailed unless detailed.nil?
      base.send :get, "/get_slideshows_by_user", options.merge(:username_for => user)
    end
    
    # Returns true if successful or raises an appropriate exception if not.
    # Takes the following options:
    # 
    # * <tt>:slideshow_title</tt> - Title for the slideshow
    # * <tt>:slideshow_description</tt> - Description for the slideshow
    # * <tt>:slideshow_tags</tt> - Tags for the slideshow. Multiple tags should be separated
    #   by spaces, using quotes to create individual multiple word tags.
    # * <tt>:make_slideshow_private</tt> - Set to <tt>true/false</tt> to change the privacy
    #   setting appropriately
    # 
    # The following options will only be used if <tt>:make_slideshow_private</tt> is set
    # <tt>true</tt>:
    # 
    # * <tt>:generate_secret_url</tt> - Set to <tt>true/false</tt> to generate a secret URL
    # * <tt>:allow_embeds</tt> - Set to <tt>true/false</tt> to allow websites to embed
    #   the private slideshow
    # * <tt>:share_with_contacts</tt> - Set to <tt>true/false</tt> to allow your contacts to
    #   view the private slideshow
    def update(id, username, password, options = {})
      force_boolean_params_to_letters! options
      base.send(:post, "/edit_slideshow", options.merge(:slideshow_id => id,
        :username => username, :password => password))
      true # This might be too naïve but should have already raised exception if unsuccessful
    end
    
    # Returns true if successful or raises an appropriate exception if not.
    def delete(id, username, password)
      base.send :post, "/delete_slideshow", :slideshow_id => id,
        :username => username, :password => password
      true # This might be too naïve but should have already raised exception if unsuccessful
    end
    
  private
    def force_boolean_params_to_letters!(hash)
      [
        :make_src_public, :make_slideshow_private, :generate_secret_url,
        :allow_embeds, :share_with_contacts
      ].each do |key|
        value = hash.delete(key)
        unless value.nil?  
          hash[key] = convert_to_letter(value, true)
        end
      end
    end
    
    def convert_to_letter(value, force = false)
      case value
      when false, "N", nil
        force ? "N" : nil
      when true, "Y"
        "Y"
      end
    end
    
    def convert_to_number(value, force = false)
      case value
      when false, 0, nil
        force ? 0 : nil
      when true, 1
        1
      end
    end
  end
end