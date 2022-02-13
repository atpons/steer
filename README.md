# steer

Home Kubernetes Cluster with ...

- mitamae
- hocho
- kubeadm
- Cilium (w/o kube-proxy)
- MetalLB

Not ready for master HA

## How to deploy

1. Edit IP Address `ops/hosts.yml` for my network
2. Run `bundle exec hocho apply <NEW_NODE>`

### Preparing kubeadm

(In master node)

```shell
sudo kubeadm init --skip-phases=addon/kube-proxy
```

After initialization, join other node following prompt

### Installing Cilium

```shell
helm install cilium ./base/cilium/values.yaml --version 1.11.90 \
    --namespace kube-system \
    --set kubeProxyReplacement=strict \
    --set k8sServiceHost=<MASTER_IP> \
    --set k8sServicePort=6443
```

### Installing MetalLB (L2 mode)

```shell
helm upgrade --install metallb metallb/metallb -f ./base/metallb/values.yaml
```

## Acknowledgements

See `CREDITS.md`

- [cilium/cilium](https://github.com/cilium/cilium)
- [metallb/metallb](https://github.com/metallb/metallb)
- [moritzheiber/laptop-provisioning](https://github.com/moritzheiber/laptop-provisioning)
- [ruby/ruby-infra-recipe](https://github.com/ruby/ruby-infra-recipe)
