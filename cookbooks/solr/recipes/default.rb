#
# Cookbook Name:: solr
# Recipe:: default
#

require 'digest/sha1'

node[:applications].each do |app,data|

  directory "/data/#{app}/jettyapps/solr" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end

  directory "/var/run/solr" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end

  template "/engineyard/bin/solr" do
    source "solr.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    variables({
      :rails_env => node[:environment][:framework_env]
    })
  end

  template "/etc/monit.d/solr.#{app}.monitrc" do
    source "solr.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :app => app
    })
  end

  execute "restart-monit-solr" do
    command "/usr/bin/monit restart all -g solr_#{app}"
    action :run
  end

end
