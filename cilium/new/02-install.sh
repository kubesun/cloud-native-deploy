#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

k8sServiceHost="192.168.3.100"
k8sServicePort=6443
podCIDR="10.244.0.0/16"
devices="enp0s5"
cilium install cilium cilium/cilium --namespace kube-system \
   --set nodeinit.enabled=true \
	 --set k8sClientRateLimit.qps=50 \
	 --set k8sClientRateLimit.burst=100 \
	 --set rollOutCiliumPods=true \
	 --set bpf.masquerade=true \
	 --set bpfClockProbe=true \
	 --set bpf.preallocateMaps=true \
	 --set bpf.tproxy=true \
	 --set bpf.hostLegacyRouting=false \
	 --set autoDirectNodeRoutes=true \
	 --set localRedirectPolicy=true \
	 --set ciliumEndpointSlice.enabled=false \
	 --set externalIPs.enabled=true \
	 --set hostPort.enabled=true \
	 --set socketLB.enabled=true \
	 --set nodePort.enabled=true \
	 --set sessionAffinity=true \
	 --set annotateK8sNode=true \
	 --set nat46x64Gateway.enabled=false \
	 --set ipv6.enabled=false \
	 --set pmtuDiscovery.enabled=true \
	 --set enableIPv6BIGTCP=false \
	 --set sctp.enabled=false \
	 --set wellKnownIdentities.enabled=true \
	 --set hubble.enabled=true \
	 --set ipam.mode=cluster-pool \
	 --set ipam.podCIDR=$podCIDR \
	 --set ipv4NativeRoutingCIDR=$podCIDR \
	 --set autoDirectNodeRoutes=true \
	 --set installNoConntrackIptablesRules=true \
	 --set enableIPv4BIGTCP=false \
	 --set egressGateway.enabled=false \
	 --set endpointRoutes.enabled=false \
	 --set kubeProxyReplacement=true \
	 --set routingMode=native \
	 --set loadBalancer.mode=dsr \
	 --set bandwidthManager.enabled=true \
	 --set bandwidthManager.bbr=true \
	 --set highScaleIPcache.enabled=false \
	 --set l2announcements.enabled=true \
	 --set devices=$devices \
	 --set l2podAnnouncements.interface=$devices \
	 --set operator.rollOutPods=true \
	 --set authentication.enabled=false \
	 --set k8sServiceHost=$k8sServiceHost \
	 --set k8sServicePort=$k8sServicePort

cilium upgrade cilium/cilium \
--namespace kube-system \
--reuse-values \
--set socketLB.hostNamespaceOnly=true \
