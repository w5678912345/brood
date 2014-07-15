# encoding: utf-8
class Gold::AppController < ApplicationController
	load_and_authorize_resource :class => "Gold"
end