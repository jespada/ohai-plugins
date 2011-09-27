#
# Author:: Jorge Espada <espada.jorge@gmail.com>
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#Provides  information about Linux lxc-containers

provides "linux/lxc"
require_plugin "virtualization"

#Grab info from the guests containers
if virtualization[:system] == "linux-lxc" && virtualization[:role] == "host"
   virtualization[:lxc] = Mash.new
  #created containers
  lxc_guests = %x{lxc-ls}.split.uniq
  #Running continers
  lxc_running =  %x{netstat -xa | grep /var/lib/lxc | awk '{print $9}'}.split.each {|g| g.gsub!("@/var/lib/lxc/","").gsub!("/command","")}

  virtualization[:lxc][:guests] = {}
  lxc_guests.each do |g|
    virtualization[:lxc][:guests]["#{g}"] = {}
    virtualization[:lxc][:guests]["#{g}"]["running"] = "no"
   end
    lxc_running.each do |r|
    virtualization[:lxc][:guests]["#{r}"]["running"] = "yes"
    end
end


