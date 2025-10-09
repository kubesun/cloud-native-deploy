#!/bin/bash

set -x

mkdir -p /home/kubernetes/postgres
cd /home/kubernetes/postgres

#helm install postgres oci://registry-1.docker.io/bitnamicharts/postgresql

VERSION="16.7.27"
# https://artifacthub.io/packages/helm/bitnami/postgresql?modal=install
wget https://charts.bitnami.com/bitnami/postgresql-${VERSION}.tgz

#helm pull ingress-nginx/ingress-nginx --untar --untar-dir /path/to/directory

tar -zxvf postgresql-${VERSION}.tgz

# 根据你的 kubectl get sc 输出，你有几个选择。
# 对于 PostgreSQL，您应该使用提供高可用性和数据持久性的 StorageClass，
# 例如由 OpenEBS Mayastor 支持的 StorageClass。
# 如果您没有可用的 Mayastor StorageClass，您可以临时使用 openebs-lvmpv 进行测试，但它缺少数据复制。
# 假设你有一个合适的，比如 openebs-mayastor。把它的sc名称添加到primary.persistence.storageClassName=<sc-name>参数里
kubectl get sc

helm upgrade --install postgres ./postgresql \
  -n postgres \
  --create-namespace \
  --set global.postgresql.auth.username="postgres" \
  --set global.postgresql.auth.password="msdnmm" \
  --set global.postgresql.auth.database="postgres" \
  --set primary.service.type=LoadBalancer \
  --set global.postgresql.service.ports.postgresql="5432" \
  --set primary.persistence.storageClass="openebs-lvmpv-postgres" \
  --set volumePermissions.enabled=true

set +x
