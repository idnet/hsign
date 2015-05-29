# Digiweb

This gem aims at signing for cross-application request

## Installation

Add this line to your application's Gemfile:

    gem 'hsign'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hsign

## Usage

For Web application use, a good salt is the IP of the browser

*Never pass the API SECRET in the request*

In consumer (client side) controller

    credentials = {'email' => 'user@example.com', 'password' => '123456', 'client_id' => "sha1apikey", 'response_type' => 'code', 'redirect_uri' => settings[:redirect_uri]}

    @hsign = HSign::Digest.new("api_secret", request.ip)
    @hsign.sign credentials

In your view

    <%= form_tag "http://otherserver.com/api/example" do %>
      <% @hsign.each_param do |field, value| %>
        <%= hidden_field_tag field, value %>
      <% end %>
      <%= submit_tag "Submit" %>
    <% end %>


Verification (server side)

    client = Idnet::Core:Client.find params[:client_id]
    secret = client.secret
    @hsign = HSign::Digest.new(secret, request.ip)
    if @hsign.verify? request.params
      account = Idnet::Core::Account.create email: params[:email], password: params[:password]
      account.confirm!
    end
