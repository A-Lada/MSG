# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'securerandom'
require 'aescrypt'
#require 'sinatra/captcha'

enable :sessions


class Message < ActiveRecord::Base
  validates :body, presence: true
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      "test"
    end
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  @messages = Message.order("created_at DESC")
  @title = "Welcome."
  erb :"messages/index"
end

# create message
get "/messages/create" do
  @title = "Create message"
  @message = Message.new
  erb :"messages/create"
end

post "/messages" do
  @message = Message.new(params[:message])
  @message.body = AESCrypt.encrypt(@message.body, "p4ssw0rd")
  @message.link = SecureRandom.uuid
  # TODO : change this
  @href = "https://limitless-bastion-17201.herokuapp.com/messages/" + @message.link
  #@href = "http://localhost:4567/messages/" + @message.link

  if @message.save
    redirect "", :notice => 'New message!' + '<a href="/messages/' + @message.link + '">' + @href + '</a>' + ' (This message will disappear in 4 seconds.)'
  else
    redirect "messages/create", :error => 'Something went wrong. Try again. (This message will disappear in 4 seconds.)'
  end
end

# view message
get "/messages/:link" do
  @message = Message.where(link: params[:link]).first

  if(@message.nil?)
    redirect to("/"), :notice => 'Message was deleted or doesn\'t exist, sorry!'
  end

  @message.body = AESCrypt.decrypt(@message.body, "p4ssw0rd")
  
  if @message.method == "on_visit"
    Message.delete(@message.id)
  else    
    timer = Timer.new
    distance_between = timer.distance_between(@message.created_at, DateTime.now) 
    if distance_between >= 1    
      Message.delete(@message.id)
      redirect to("/"), :notice => 'Message ' + @message.link + ' deleted on time'
    end
  end

  erb :"messages/view"
end

class Timer
  def distance_between(start_date, end_date)
      difference = end_date.to_i - start_date.to_i
      seconds    =  difference % 60
      difference = (difference - seconds) / 60
      minutes    =  difference % 60
      difference = (difference - minutes) / 60
      hours      =  difference % 24    
      return hours
  end
end
