execute "testing" do
  command %Q{
    echo "i ran at #{Time.now}" >> /root/cheftime
  }
end

if node[:instance_role] == "solo" || node[:instance_role] == "app_master"
  execute "Seeding database" do
    cwd "/data/LabDay/current"
    command 'rake db:seed --trace'
  end
end

if node[:instance_role] == "solo" || node[:instance_role].match(/^app/)
  require_recipe "nginx_configurations"
end

if node[:instance_role] == "solo" || (node[:name] && node[:name].upcase == 'SOLR')
  require_recipe 'solr'
end

if node[:instance_role] == "solo" || node[:instance_role].match(/^app/)
  command %Q{
    echo "Configuring solr client" >> /root/chefsolrclient
  }
  require_recipe 'solr_client'
else
  command %Q{
    echo "Not Configuring solr client" >> /root/chefsolrclient
  }
end

# uncomment if you want to run couchdb recipe
# require_recipe "couchdb"

# uncomment to turn your instance into an integrity CI server
#require_recipe "integrity"

# uncomment to turn use the MBARI ruby patches for decreased memory usage and better thread/continuationi performance
# require_recipe "mbari-ruby"
