user 'jenkins' do
    home '/home/jenkins'
    shell '/bin/bash'
    password '$1$RDXR2jjd$vhiK.lztBQ43bjtr0xIjM/'
    action :create
end

directory '/home/jenkins' do
    owner 'jenkins'
    group 'jenkins'
end

directory '/home/jenkins/.ssh' do
    owner 'jenkins'
    group 'jenkins'
	mode '0700'
end

#grant user permission to jenkins
bash 'add-public-key' do
	user 'root'
	code <<-EOH
	cat /home/ec2-user/.ssh/authorized_keys >> /home/jenkins/.ssh/authorized_keys
	chmod 600 /home/jenkins/.ssh/authorized_keys
	chown jenkins /home/jenkins/.ssh/authorized_keys
	chgrp jenkins /home/jenkins/.ssh/authorized_keys
	EOH
end


bash 'install-ant' do
	user 'root'
	code <<-EOH
	yum -y update
	yum -y install java
	yum -y install ant
	EOH
end

Chef::Log.info("***************** Jenkins slave setup finished **************")