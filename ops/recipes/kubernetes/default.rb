# Disable Swap
execute "sed -i -e 's/^\\/swap/#\\/swap/g' /etc/fstab"

%w[iptables arptables ebtables].each do |pkg|
  package pkg
end

{
  "iptables" => "iptables-legacy",
  "ip6tables" => "ip6tables-legacy",
  "arptables" => "arptables-legacy",
  "ebtables" => "ebtables-legacy"
}.each do |new, legacy|
  execute "sudo update-alternatives --set #{new} /usr/sbin/#{legacy}"
end

%w[containerd.io].each do |pkg|
  package pkg
end

execute "containerd config default | sudo tee /etc/containerd/config.toml"

service 'containerd' do
  action [:restart]
end

%w[kubelet kubeadm kubectl].each do |pkg|
  package pkg
  execute "apt-mark hold #{pkg}" do
    not_if { run_command("apt-mark showhold").stdout.split("\n").include?(pkg) }
  end
end

file "/etc/modules-load.d/containerd.conf" do
  content <<EOF
overlay
br_netfilter
EOF
end

execute "modprobe overlay"
execute "modprobe br_netfilter"


file "/etc/sysctl.d/k8s.conf" do
  content <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
end

execute "sysctl --system"

package "helm"
