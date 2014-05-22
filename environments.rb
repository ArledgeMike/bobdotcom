SITE_URL = "http://www.codeandpen.com/uploads/"
EMPLOYEE_TYPE = ["ceo", "art", "copy", "tech"]

configure :development do
	set :database, 'postgres://xrhebywahsgool:QeAKkl-KIh3UI5kLPbB51c9G5e@ec2-54-83-204-104.compute-1.amazonaws.com:5432/d5qgu2g7ch4grh'
	set :show_exceptions, true
end

configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://xrhebywahsgool:QeAKkl-KIh3UI5kLPbB51c9G5e@ec2-54-83-204-104.compute-1.amazonaws.com:5432/d5qgu2g7ch4grh')

	ActiveRecord::Base.establish_connection(
		:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host => db.host,
		:username => db.user,
		:password => db.password,
		:database => db.path[1..-1],
		:encoding => 'utf8'
	)
end

