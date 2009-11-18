#
# Cookbook Name:: solr_client
# Recipe:: default
#

require 'digest/sha1'

utility_slice = node[:utility_instances].detect {|n| n[:name].upcase == "SOLR"}
if utility_slice
  node[:applications].each do |app,data|
    template "/data/#{app}/current/config/solr.yml" do
      source "solr.yml.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      variables({
        :rails_env => node[:environment][:framework_env],
        :server_hostname => utility_slice[:hostname]
      })
    end

    execute "restart-app-servers" do
      command "/usr/bin/monit reload && " +
              "/usr/bin/monit restart all -g #{app}"
      action :run
    end
  end
end