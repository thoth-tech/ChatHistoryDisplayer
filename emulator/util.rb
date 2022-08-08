# Utility functions used by our server 
class Response

    #Generic server response 
    def self.generic(code, message)
        return {Code: code, Message: message}.to_json
    end

end
