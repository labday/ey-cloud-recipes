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
        :server_name => data[:vhosts].first[:name]
      )
      action :create
    end
  end
  
  template "/data/nginx/servers/LabDay.rewrites" do
    owner node[:users].first[:username]
    group node[:users].first[:gid]
    mode 0644
    source "rewrites.erb"
    variables(
      :server_name => data[:vhosts].first[:name]
    )
    action :create
  end
end
