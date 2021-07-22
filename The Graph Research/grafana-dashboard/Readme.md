# Metric Analytics 

Queries are obtained by subgraph [balancer](https://thegraph.com/legacy-explorer/subgraph/balancer-labs/balancer) and [uniswapv3](https://thegraph.com/legacy-explorer/subgraph/uniswap/uniswap-v3) . The subgraph is scraped and exported to [graphql exporter](https://github.com/ricardbejarano/graphql_exporter) and then to [prometheus](https://prometheus.io/). Alternatively you may use GraphQL Data Source (https://grafana.com/grafana/plugins/fifemon-graphql-datasource/) for simple query visualizations but the support to BigInt and BigDecimal is not yet extended as of July2021.

The Dashboard is visualised in [Grafana] (https://grafana.com/)

## Getting Started 

1. Install Prometheus, Grafana and extract graphQL exporter.  
3. View prometheus at `http://localhost:9090/targets` and grafana at `localhost:3000`