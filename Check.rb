#!/usr/bin/ruby

class Check

	def initialize(description, repo_info, cfgFilePath)
		@name = description
		@repo = repo_info
		@cfgPath = cfgFilePath
	end

	def name
		return @name
	end

	def running?
		return true
	end
	
end
