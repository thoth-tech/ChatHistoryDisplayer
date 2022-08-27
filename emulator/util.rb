# Utility functions used by our server 
class Response

    #Generic server response 
    def self.generic(code, message)
        return {Code: code, Message: message}.to_json
    end
    #Response containing the outocme out a dif search with an attached SHA if one was found
    def self.diffOutcome(found, sha)
        return {Found: found, sha: sha}.to_json
    end

end

