require 'sinatra/base'
require 'sinatra/activerecord'

#Controller reqs
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/AttemptController'
require './controllers/ExcerptController'

#Model reqs
require './models/UserModel'
require './models/AttemptModel'
require './models/ExcerptModel'

map('/') {
	run ApplicationController
}
map('/users') {
	run UserController
}
map('/attempts') {
	run AttemptController
}
map('/excerpts') {
	run ExcerptController
}