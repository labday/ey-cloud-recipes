#
# Cookbook Name:: whenever
# Recipe:: default
#

node[:applications].each do |app,data|
  if node[:instance_role] == "util"
    directory "/var/log/engineyard/rails" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0755
    end
  
    directory "/var/log/engineyard/rails/#{app}" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0755
    end
  
    link "/data/#{app}/shared/log" do
      to "/var/log/engineyard/rails/#{app}" 
    end
  
    logrotate "rails" do
      files "/var/log/engineyard/rails/*/*.log"
      copy_then_truncate true
    end
  end
  
  execute "Generating Whenever Cron" do
    cwd "/data/#{app}/current"
    command "whenever --write-crontab -u #{node[:owner_name]} --set environment=#{node[:environment][:framework_env]}"
  end
end