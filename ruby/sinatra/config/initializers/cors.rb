require "sinatra/cross_origin"

configure do
  enable :cross_origin
end

before do
  response.headers["Access-Control-Allow-Headers"] = "Authorization"
  response.headers["Access-Control-Allow-Methods"] = "GET, PUT, PATCH, POST, DELETE, OPTIONS, HEAD"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Expose-Headers"] = "Authorization"
end
