#!/usr/bin/ruby

require_relative 'Check'

class CheckManager
	def initialize
		@checks = {:XasWorks => {:Notos => {"asd0918i8das" => Check.new("Test Check", "No Info here! :P", "."),
														"pfrlplpasdaw" => Check.new("Also test check", "BKA", ".")}}}
	end

	def each
		@checks.each do |owner, repoHash|
			repoHash.each do |repo, checkHash|
				checkHash.each do |commit, check|
					yield({:owner => owner, :repo => repo, :commit => commit}, check)
				end
			end
		end
	end

	def numActive
		active = 0

		self.each do |callerInfo, check|
			if check.respond_to? "running?"
				active += 1 if check.running?
			end
		end

		return active
	end

	def has?(owner, repo)
		@checks[owner.to_sym].key?(repo.to_sym) if @checks.key?(owner.to_sym)
	end
end
