SITE_URL = "http://www.localhost:4567/uploads/"

configure :development do
	set :database, 'postgres://postgres:psirus2050@localhost:5432/bobdotcom'
	set :show_exceptions, true
end

configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://qchpngtedqreqj:duWMP7LJWhAmymwUO7x_scGN6B@ec2-54-221-223-92.compute-1.amazonaws.com:5432/d9s4lg1unsugtu')

	ActiveRecord::Base.establish_connection(
		:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host => db.host,
		:username => db.user,
		:password => db.password,
		:database => db.path[1..-1],
		:encoding => 'utf8'
	)
end

