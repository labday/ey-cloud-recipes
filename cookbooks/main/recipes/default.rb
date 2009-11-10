execute "testing" do
  command %Q{
    echo "i ran at #{Time.now}" >> /root/cheftime
  }
end

execute "Seeding database" do
  cwd "/data/LabDay/current"
  command 'rake db:seed --trace'
end

require_recipe "nginx_configurations"

#require_recipe "solr"

# uncomment if you want to run couchdb recipe
# require_recipe "couchdb"

# uncomment to turn your instance into an integrity CI server
#require_recipe "integrity"

# uncomment to turn use the MBARI ruby patches for decreased memory usage and better thread/continuationi performance
# require_recipe "mbari-ruby"
