# frozen_string_literal: true

# Utility functions used by our server
class Response
  # Generic server response
  def self.generic(code, message)
    { Code: code, Message: message }.to_json
  end

  # Response containing the outocme out a dif search with an attached SHA if one was found
  def self.diff_outcome(found, sha)
    { Found: found, sha: sha }.to_json
  end

  def self.generic_text(code, message)
    { Code: code, Message: message }
  end
end
