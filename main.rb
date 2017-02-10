#!/usr/bin/ruby

require 'sinatra'
require 'rdiscount'

require_relative 'checker'

checks = Checker.new

get '/ci' do
	erb :CIOverview, :locals => {:checker => checks}
end

get '/ci/:owner/:repository' do
	erb :CIDetails, :locals => {:owner => params[:owner], :repository => params[:repository],
															:checker => checks }
end

get '/about' do
	markdown :README
end
