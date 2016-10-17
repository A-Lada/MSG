configure :development do
 set :database, 'sqlite:///dev.db'
 set :show_exceptions, true
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb') #'postgres://ajotjhlnhnlkyd:nj8ENTvZNawUmIb-W4AN_qL54T@ec2-54-235-99-22.compute-1.amazonaws.com:5432/d1vfd1cfsgq8iv' ) 

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end
