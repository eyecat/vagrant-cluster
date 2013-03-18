# -*- mode: ruby -*-
# vi: set ft=ruby :
#require 'chef'
#require 'chef/config'
#require 'chef/knife'
current_dir = File.dirname(__FILE__)
#Chef::Config.from_file(File.join(current_dir, '.chef', 'knife.rb'))
boxes = [
  { :name => :master,    :role => 'master_role',     :ip => '192.168.56.11', :ssh_port => 2201, :http_fwd => 9980, :cpus =>1, :mem =>768, :shares => true },
  { :name => :slave1,        :role => 'slave_role',         :ip => '192.168.56.12', :ssh_port => 2202, :mysql_fwd => 9936, :cpus =>1, :mem =>768 }
]

Vagrant::Config.run do |global_config|
  chef_default = proc do |chef|
    chef.cookbooks_path = ['cookbooks', 'vendor_cookbooks']
    chef.log_level = :debug
    chef.roles_path = "roles"
  end
  boxes.each do |opts|

    global_config.vm.define opts[:name] do |config|
      config.vm.box        = "precise64"
  
      config.vm.forward_port  80, opts[:http_fwd] if opts[:http_fwd]
      config.vm.forward_port  3306, opts[:mysql_fwd] if opts[:mysql_fwd]
      config.vm.network       :hostonly, opts[:ip]
      config.vm.host_name =   "%s.vagrant" % opts[:name].to_s
  
      # config.vm.share_folder  "stuff", "/usr/local/stuff", "~/Projects/stuff", :nfs => true if opts[:shares]
      # use nfs rather than VirtualBox shared files.  It's heaps faster.
  
      config.vm.forward_port 22, opts[:ssh_port], :auto => true
  
      config.vm.customize ["modifyvm", :id, "--cpus", opts[:cpus] ] if opts[:cpus] 
      config.vm.customize ["modifyvm", :id, "--memory", opts[:mem] ] if opts[:mem] 
      # cpus defaults to 1
  
      config.vm.provision :chef_solo do |chef|
        chef_default.call(chef)
        chef.add_role opts[:role].to_s
      end
    end
  end
end