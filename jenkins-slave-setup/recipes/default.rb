
Chef::Log.info("***test 1***")
user 'jenkins' do
    home '/home/jenkins'
    shell '/bin/bash'
    action :create
end

Chef::Log.info("***test 2***")
directory '/home/jenkins' do
    owner 'jenkins'
    group 'jenkins'
end

Chef::Log.info("***test 3***")
directory '/home/jenkins/.ssh' do
	owner 'jenkins'
	group 'jenkins'
	mode '0700'
end

Chef::Log.info("***test 4***")
#grant user permission to jenkins
bash 'add-public-key' do
	user 'root'
	code <<-EOH
	cat /home/ec2-user/.ssh/authorized_keys >> /home/jenkins/.ssh/authorized_keys
	chmod 600 /home/jenkins/.ssh/authorized_keys
	chown jenkins /home/jenkins/.ssh/authorized_keys
	chgrp jenkins /home/jenkins/.ssh/authorized_keys
	echo "jenkins  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoer
	EOH
end


Chef::Log.info("***test 5***")
bash 'install-ant' do
	user 'root'
	code <<-EOH
	yum -y update
	yum -y install java
	yum -y install ant
	EOH
end


Chef::Log.info("***test 6***")
#install docker
bash 'install-docker' do
	user 'root'
	code <<-EOH
	yum -y install docker
	service docker start
	usermod -aG docker jenkins
	echo "# /etc/sysconfig/docker" > /etc/sysconfig/docker
	echo 'other_args="--insecure-registry dcsrd-docker-registry.trendmicro.com"' >> /etc/sysconfig/docker
	service docker restart
	EOH
end

Chef::Log.info("***test 7***")

#create dir
directory '/media/ephemeral0/jenkins' do
	owner jenkins
	group jenkins
	recursive true
end

Chef::Log.info("***************** Jenkins slave setup finished **************")
