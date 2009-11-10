#
# Cookbook Name:: nginx_redirect_subdomains_to_toplevel
# Recipe:: default
#
node[:applications].each do |app, data|
  if data[:vhosts].first[:name].match(/^www\./)
    template "/data/nginx/servers/#{app}_redirect_root_domain.conf" do
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
end
