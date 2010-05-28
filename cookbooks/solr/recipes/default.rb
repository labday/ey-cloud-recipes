#
# Cookbook Name:: solr
# Recipe:: default
#
<<<<<<< HEAD

require 'digest/sha1'

node[:applications].each do |app,data|

  directory "/data/#{app}/jettyapps" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end

  directory "/var/run/solr" do
=======
# We specify what version we want below.
solr_desiredversion = 1.4
if ['solo', 'util'].include?(node[:instance_role])
  if solr_desiredverison = 1.3
    solr_file = "apache-solr-1.3.0.tgz"
    solr_dir = "apache-solr-1.3.0"
    solr_url = "http://mirror.its.uidaho.edu/pub/apache/lucene/solr/1.3.0/apache-solr-1.3.0.tgz"
  else
    solr_dir = "apache-solr-1.4.0"
    solr_file = "apache-solr-1.4.0.tgz"
    solr_url = "http://mirror.its.uidaho.edu/pub/apache/lucene/solr/1.4.0/apache-solr-1.4.0.tgz"
  end

  directory "/var/run/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/solr" do
    action :create
>>>>>>> engineyard/master
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
<<<<<<< HEAD
    variables({
      :rails_env => node[:environment][:framework_env]
    })
  end

  template "/etc/monit.d/solr.#{app}.monitrc" do
=======
  variables({
    :rails_env => node[:environment][:framework_env]
  })
  end

  template "/etc/monit.d/solr.monitrc" do
>>>>>>> engineyard/master
    source "solr.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
<<<<<<< HEAD
      :app => app,
      :username => node[:owner_name]
    })
  end

  execute "install solr example package" do
    command("if [ ! -e /data/#{app}/jettyapps/solr ]; then cd /data/#{app}/jettyapps && " +
            "wget -O apache-solr-1.3.0.tgz http://mirror.cc.columbia.edu/pub/software/apache/lucene/solr/1.3.0/apache-solr-1.3.0.tgz && " +
            "tar -xzf apache-solr-1.3.0.tgz && " +
            "mv apache-solr-1.3.0/example solr && " + 
            "rm -rf apache-solr-1.3.0; fi")
    action :run
  end

  link "/data/#{app}/jettyapps/solr/solr/conf/schema.xml" do
    to "/data/#{app}/current/vendor/plugins/acts_as_solr/solr/solr/conf/schema.xml"
  end

  link "/data/#{app}/jettyapps/solr/solr/conf/solrconfig.xml" do
    to "/data/#{app}/current/vendor/plugins/acts_as_solr/solr/solr/conf/solrconfig.xml"
  end

  execute "restart-monit-solr" do
    command "/usr/bin/monit reload && " +
            "/usr/bin/monit restart all -g solr_#{app}"
    action :run
  end

=======
      :user => node[:owner_name],
      :group => node[:owner_name]
    })
  end

  remote_file "/data/#{solr_file}" do
    source "#{solr_url}"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    not_if { FileTest.exists?("/data/#{solr_file}") }
  end

  execute "unarchive solr-to-install" do
    command "cd /data && tar zxf #{solr_file} && sync"
    not_if { FileTest.directory?("/data/#{solr_dir}") }
  end

  execute "install solr example package" do
    command "cd /data/#{solr_dir} && mv example /data/solr"
    not_if { FileTest.exists?("/data/solr/start.jar") }
  end

   directory "/data/solr" do
    action :create
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

   execute "chown_solr" do
     command "chown #{node[:owner_name]}:#{node[:owner_name]} -R /data/solr"
   end

   execute "monit-reload" do
     command "monit quit && telinit q"
   end

   execute "start-solr" do
     command "sleep 3 && monit start solr_9080"
   end
>>>>>>> engineyard/master
end
