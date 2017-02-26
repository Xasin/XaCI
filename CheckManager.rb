#!/usr/bin/ruby2.0

require_relative 'StatCheck'

class CheckManager
	def initialize
		@checks = Hash.new();
	end

	def each
		@checks.each do |statHash, statCheck|
			yield(statCheck);
		end
	end

	def numActive
		active = 0

		self.each do |statCheck|
			if statCheck.respond_to? "status?"
				active += 1 if (statCheck.status? == 'pending')
			end
		end

		return active
	end

	def has?(owner, repo)
		hasCheck = false;

		self.each do |check|
			hasCheck = true if check.info[:repo] == "#{owner}/#{repo}";
			break;
		end

	end
end
