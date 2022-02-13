%w[apt-transport-https ca-certificates curl software-properties-common].each do |pkg|
  package pkg
end

{
  "https://download.docker.com/linux/ubuntu focal stable" => 'https://download.docker.com/linux/ubuntu/gpg',
  "https://apt.kubernetes.io/ kubernetes-xenial main" => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
  "https://baltocdn.com/helm/stable/debian/ all main" => "https://baltocdn.com/helm/signing.asc",
}.each do |url, key|
  apt_repository "deb [arch=amd64] #{url}" do
    gpg_key key
  end
end
