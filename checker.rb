#!/usr/bin/ruby

class Checker
	def initialize
		@checks = Hash.new;

		@checks[:XasWorks][:Notos] = 1;
	end

	def active?
		@checks.length
	end

	def has?(owner, repo)
		@checks[owner.to_sym].key?(repo.to_sym) if @checks.key?(owner.to_sym)
	end
end
