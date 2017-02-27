#!/usr/bin/ruby

require 'xxhash'
require 'octokit'
require 'yaml'

LOGDIR="/home/xasin/Xasin/XaCI/.logs/"

class StatCheck
	private
	def setStatus(status, description=@testData["description"])
		@status = status;
		@@octoNection.create_status(	@repoData[:repo],
												@repoData[:commit],
												status,
												:context => "XaCI/#{@testData["name"]}",
												:description => description,
												:target_url => "http://www.xasin.selfhost.eu/CI/#{@repoData["repo"]}/#{@repoData["commit"]}/#{@testData["name"]}");
	end

	def logdir
		File.join(LOGDIR, self.hash.to_s)
	end

	def setupLogDir
		`rm -r #{logdir}`
		`mkdir #{logdir}`
	end

	public
	def StatCheck.connect
		@@octoNection = Octokit::Client.new(:access_token => File.read("ACCESS_TOKEN"));
	end

	def initialize(repo, commit, pr, targetFile)
		@repoData = {
			:repo => repo,
			:commit => commit,
			:pr => pr,
		}
		@targetFile = targetFile
		@testData = YAML.load(File.read(targetFile));
		@creationTime = Time.now;

		setupLogDir

		setStatus('pending');
	end

	def eql?(other)
		(self.hash == other.hash) and (other.is_a? StatCheck)
	end
	alias == eql?

	def hash
		XXhash.xxh64(@repoData[:repo] + @repoData[:commit] + @testData["name"]);
	end

	def status?
		return @status
	end

	def info
		return { :repo => @repo,
					:commit => @commit,
					:status => @status,
					:targetFile => @targetFile,
					:testData => @testData };
	end

	def getFiles
		@testData["all_files"] = `find #{File.dirname(@targetFile)} -regex #{@testData["files"]}`.split("\n").map { |fname|
			File.absolute_path(fname);
		}
	end

	def getParam(parameter)
		if not @testData["parameters"] then
			return ""
		else
			return @testData["parameters"].fetch(parameter, "")
		end
	end

	def replaceParams(input, current_file="")
		input.gsub(/!(\w+)(\.\w+)?/) {|match|
			match = match.match(/!(\w+)(\.\w+)?/)

			if match[1] == "INPUT_FILE" then
				if match[2] then
					current_file.gsub(/\.\w+$/, "") + match[2]
				else
					current_file
				end

			elsif match[1] == "INPUT_FILES" then
				if match[2] then
					@testData["all_files"].map {|fname|
						fname.gsub(/\.\w+$/, "") + match[2]
					}.join(" ")
				else
					@testData["all_files"].join(" ")
				end

			else
				getParam(match[1])
			end
		}
	end

	def runCommand(tName)
		return false unless @testData["commands"][tName]
		command = @testData["commands"][tName]

		logfile = File.join(logdir, @testData["name"]);
		puts "Logfile at: #{logfile}"

		`echo "\n---------- START OF: #{tName} ----------" >> #{logfile}`

		if(command["single_file"]) then
			@testData["all_files"].each { |targetFile|
				cmd = replaceParams(command["cmd"], targetFile)

				`echo "\nRunning: #{cmd}" >> #{logfile}`
				`#{cmd} 2>>#{logfile} >>#{logfile}`
			}
		else
			puts replaceParams(command["cmd"])
		end
	end

	def runTest
		getFiles

		runCommand("Check")
	end
end

StatCheck.connect;
testCheck = StatCheck.new("XasWorks/Notos", "87069ae844850b4a297fe34e89603351492e1c9a", 49, "/home/xasin/XasWorks/Notos/OpenSCAD.XaCI");

testCheck.runTest
