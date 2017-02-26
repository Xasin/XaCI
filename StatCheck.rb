
#!/usr/bin/ruby

require 'xxhash'
require 'octokit'

class StatCheck
	private
	def setStatus(status)
		@status = status;
		@@octoNection.create_status(@repo, @commit, status, :context => "XaCI/#{@targetFile}", :description => "A test test!", :target_url => "http://www.xasin.selfhost.eu/CI/#{@repo}/#{@pr}/#{@commit}/#{@targetFile}");
	end

	public
	def StatCheck.connect
		@@octoNection = Octokit::Client.new(:access_token => );
	end

	def initialize(repo, commit, pr, targetFile)
		@repo = repo;
		@commit = commit;
		@pr = pr;

		@targetFile = targetFile;

		@creationTime = Time.now;

		#self.setStatus('success');
	end

	def eql?(other)
		(self.hash == other.hash) and (other.is_a? StatCheck)
	end
	alias == eql?

	def hash
		XXhash.xxh64(@repo + @commit + @targetFile);
	end

	def status?
		return @status
	end

	def info
		return { :repo => @repo,
					:commit => @commit,
					:status => @status,
					:targetFile => @targetFile,
					:name => "NAN",
					:description => "NAN"};
	end
end

StatCheck.connect;
testCheck = StatCheck.new("XasWorks/Notos", "87069ae844850b4a297fe34e89603351492e1c9a", 49, "Something?");

puts testCheck.hash
