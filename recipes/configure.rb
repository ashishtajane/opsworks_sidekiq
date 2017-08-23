# Adapted from rails::configure: https://github.com/aws/opsworks-cookbooks/blob/master/rails/recipes/configure.rb

# include_recipe "deploy"
include_recipe "opsworks_sidekiq::service"

node[:deploy].each do |application, deploy|

  unless node[:sidekiq][application]
    next
  end

  deploy = node[:deploy][application]

  execute "restart Sidekiq app #{application}" do
    cwd deploy[:current_path]
    command deploy[:restart_command]
    action :nothing
  end

  # node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(application, node[:deploy][application], "#{node[:deploy][application][:deploy_to]}/current", force: node[:force_database_adapter_detection])

  # template "#{deploy[:deploy_to]}/shared/config/database.yml" do
  #   source "database.yml.erb"
  #   cookbook 'rails'
  #   mode "0660"
  #   group deploy[:group]
  #   owner deploy[:user]
  #   variables(
  #     database: deploy[:database],
  #     environment: deploy[:rails_env]
  #   )

  #   notifies :run, "execute[restart Sidekiq app #{application}]"

  #   only_if do
  #     deploy[:database][:host].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
  #   end
  # end

  # template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
  #   source "memcached.yml.erb"
  #   cookbook 'rails'
  #   mode "0660"
  #   group deploy[:group]
  #   owner deploy[:user]
  #   variables(
  #     memcached: deploy[:memcached] || {},
  #     environment: deploy[:rails_env]
  #   )

  #   notifies :run, "execute[restart Rails app #{application}]"

  #   only_if do
  #     deploy[:memcached][:host].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
  #   end
  # end

end
