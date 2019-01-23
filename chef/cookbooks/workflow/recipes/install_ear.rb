# =================================================================
# Copyright 2018 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

#
# Cookbook Name::workflow
# Recipe::install_ear
#
# <> Installs a Mediation Module into IBM Business Automation Workflow
#

baw_admin_username = 'admin'
baw_admin_password = 'admin'

template 'Create install_ear.jy file for BAW' do
    path '/tmp/install_ear.jy'
	source 'wsadmin/install_ear.jy.erb'
    owner 'root'
    group 'root'
    mode "0644"
end

execute 'Install EAR for BAW' do
command "#{node['workflow']['install_dir']}//profiles/DmgrProfile/bin/wsadmin.sh -lang jython -f /tmp/install_ear.jy -username #{baw_admin_username} -password #{baw_admin_password}"
#user node['odm']['ds']['user']
#group node['odm']['ds']['group']
user 'root'
group 'root'
notifies :create, "file[/opt/chef/install_EAR.done]", :immediately
not_if { ::File.exist?("/opt/chef/install_EAR.done") }
end

file "/opt/chef/install_EAR.done" do
    user 'root'
    group 'root'
    mode '0644'
    action :nothing
end