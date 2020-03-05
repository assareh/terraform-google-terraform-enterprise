# Terraform Enterprise Clustered on Google Cloud Platform: Proxy

The **proxy** submodule provisions the proxy of the Terraform
Enterprise Clustered deployment. The proxy is used to overcome the lack
of support for same-host [hairpinning][hairpinning] on Google Cloud
Platform (GCP).

## Function

Some traffic which originates from the primary nodes must be
routed back to the primary nodes through the primary load balancer, but
this behaviour is not supported by GCP when the source node and the
target node are the same. To work around this limiation, the proxy
routes traffic through two load balancers with intermediate nodes
running [iptables]. This design allows traffic from all nodes to be
routed to the primary nodes.

<!-- URLS for links -->

[hairpinning]: https://en.wikipedia.org/wiki/Hairpinning
[iptables]: https://en.wikipedia.org/wiki/Iptables
[tf-registry]: https://registry.terraform.io/modules/hashicorp/terraform-enterprise/google
