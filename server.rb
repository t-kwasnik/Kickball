require 'sinatra'
require 'csv'

def filter_roster(group_by, group_by_value, descriptor)
  roster = []
  CSV.foreach('lackp_starting_rosters.csv', headers: true) do |row|
    roster << "#{row["first_name"]} #{row["last_name"]}, <a href = \"http://localhost:4567/#{descriptor}/#{row[descriptor]}\">#{row[descriptor]}</a>" if row[group_by] == group_by_value
  end
  roster
end

def unique_teams
  teams = []
  CSV.foreach('lackp_starting_rosters.csv', headers: true) do |row|
    item = "<a href = \"http://localhost:4567/team/#{row["team"]}\">#{row["team"]}</a>"
    teams << item if !teams.include?(item)
  end
  teams
end


get '/team/:team_name' do
  @title = params[:team_name]
  @list_items = filter_roster("team",@title, "position")
  # The :task_name is available in our params hash
  erb :show
end

get '/position/:position_name' do
  @title = params[:position_name]
  @list_items = filter_roster("position",@title, "team")
  # The :task_name is available in our params hash
  erb :show
end

get '/' do
  @title = "Teams"
  @list_items = unique_teams
  # The :task_name is available in our params hash
  erb :show
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
