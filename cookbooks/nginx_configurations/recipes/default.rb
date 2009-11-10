#
# Cookbook Name:: nginx_redirect_subdomains_to_toplevel
# Recipe:: default
#
node[:applications].each do |app, data|
  if data[:vhosts].first[:name].match(/^www\./)
    template "/data/nginx/servers/000_#{app}_redirect_root_domain.conf" do
      owner node[:users].first[:username]
      group node[:users].first[:gid]
      mode 0644
      source "redirect_root_domain.conf.erb"
      variables(
        :server_name => data[:vhosts].first[:name],
        :http_bind_port => data[:http_bind_port]
      )
      action :create
    end
  end

  template "/data/nginx/servers/001_#{app}_ensure_ssl.conf" do
    owner node[:users].first[:username]
    group node[:users].first[:gid]
    mode 0644
    source "ensure_ssl.conf.erb"
    variables(
      :server_name => data[:vhosts].first[:name],
      :http_bind_port => data[:http_bind_port],
      :app_name => app
    )
    action :create
  end

  template "/data/nginx/servers/#{app}/custom.locations.conf" do
    owner node[:users].first[:username]
    group node[:users].first[:gid]
    mode 0644
    source "custom.locations.conf.erb"
    variables(
      :server_name => data[:vhosts].first[:name],
      :http_bind_port => data[:http_bind_port],
      :app_name => app
    )
    action :create
  end
end
