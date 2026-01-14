# ToolHive Helm XRD Configuration

Crossplane XRD configuration for deploying ToolHive operator via Helm.

## Overview

ToolHive is a Kubernetes operator for deploying MCP (Model Context Protocol) servers, making it easy to run AI tool servers in your cluster. This XRD provides a simplified interface for deploying the ToolHive operator.

## Quick Start

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: ToolHive
metadata:
  name: toolhive
  namespace: my-namespace
spec:
  clusterName: my-cluster
```

## Configuration Options

| Field | Description | Default |
|-------|-------------|---------|
| `clusterName` | Name of the target cluster | Required |
| `namespace` | Namespace for ToolHive deployment | `toolhive-system` |
| `releaseName` | Helm release name | `<clusterName>-toolhive` |
| `labels` | Labels to apply to resources | `{}` |
| `values` | Helm values (merged with defaults) | `{}` |
| `overrideAllValues` | Replace all default values | `{}` |
| `providerConfigRef` | Provider config reference | Uses `clusterName` |
| `managementPolicies` | Crossplane management policies | `["*"]` |

## Examples

### Minimal Configuration

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: ToolHive
metadata:
  name: toolhive
  namespace: example-env
spec:
  clusterName: my-cluster
```

### Custom Namespace and Values

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: ToolHive
metadata:
  name: toolhive
  namespace: example-env
spec:
  clusterName: production-cluster
  namespace: mcp-servers
  labels:
    team: ai-platform
    environment: production
  values:
    operator:
      replicas: 2
```

## Development

```bash
# Build the package
make build

# Render all examples
make render:all

# Validate all examples
make validate:all

# Run tests
make test
```

## Chart Details

- **Chart**: `toolhive-operator`
- **Repository**: `oci://ghcr.io/stacklok/toolhive`
- **Version**: `0.5.6`
