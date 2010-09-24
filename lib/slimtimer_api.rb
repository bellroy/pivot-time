require 'httparty'
require 'yaml'

class SlimtimerApi
  include HTTParty

  attr_reader :user_id
  attr_reader :access_token

  # I'd prefer to use json instead, but slimtimer reports empty JSON objects
  # instead for time values, like:
  # {
  #   updated_at: {},
  #   created_at: {},
  #   name: 'foo',
  #   ...
  # }
  format :xml

  def initialize(api_key, email, password)
    @api_key = api_key
    get_access_token(email, password)
  end

  def get(path, query = {})
    options = {
      :headers => { "Accept" => "application/xml" },
      :base_uri => "http://www.slimtimer.com/users/#{@user_id}",
      :query => base_query.merge(query)
    }
    self.class.get(path, options)
  end

  def tasks(show_completed = 'yes', role = 'owner,coworker')
    result = get('/tasks', :show_completed => show_completed, :role => role)
    if result['tasks']
      case result['tasks']['task']
      when Hash
        [result['tasks']['task']]
      when Array
        result['tasks']['task']
      end
    else
      []
    end
  end

  def time_entries(range_start = nil, range_end = nil)
    result = get('/time_entries', :range_start => range_start, :range_end => range_end)
    if result['time_entries']
      case result['time_entries']['time_entry']
      when Hash
        [result['time_entries']['time_entry']]
      when Array
        result['time_entries']['time_entry']
      end
    else
      []
    end
  end

  private

  def get_access_token(email, password)
    response = self.class.post("http://slimtimer.com/users/token", 
      :headers => {
        "Accept"       => "application/xml",
        "Content-Type" => "application/x-yaml"
      },
      :body => {
        'user' => { 'email' => email, 'password' => password },
        'api_key' => @api_key
      }.to_yaml)
    pp response
    @user_id, @access_token = response['response']['user_id'], response['response']['access_token']
  end

  def base_query
    @base_query ||= { :api_key => @api_key, :access_token => @access_token }
  end
end
