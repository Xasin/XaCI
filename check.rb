#!/usr/bin/ruby

before do
	StatCheck.connect;
end

class StatCheck
	private
	def setStatus(status)

	end

	public
	def StatCheck.connect
		@@octoNection = Octokit::Client.new(:access_token =>);
	end

	def initialize(repo, commit, pr, targetFile)
		@repo = repo;
		@commit = commit;
		@pr = pr;

		@targetFile = targetFile;

		@creationTime = Time.now;

		self.setStatus('pending');
	end



end
