import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for ToolHive XRD
#
# Philosophy: Test YOUR API, not the provider's API.
# - render/validate already checks provider schema correctness
# - Tests should verify XRD spec fields produce expected behavior
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm release with name defaulting to XR name
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-release"
        spec = {
            compositionPath = "apis/toolhives/composition.yaml"
            xrdPath = "apis/toolhives/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "ToolHive"
                metadata.name = "test-toolhive"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "test-toolhive"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom labels are applied and merged with defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-labels-merged-with-defaults"
        spec = {
            compositionPath = "apis/toolhives/composition.yaml"
            xrdPath = "apis/toolhives/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "ToolHive"
                metadata.name = "labeled-toolhive"
                spec = {
                    clusterName = "test-cluster"
                    labels = {
                        team = "ai-platform"
                        environment = "staging"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "labeled-toolhive"
                        labels = {
                            "hops.ops.com.ai/managed" = "true"
                            "hops.ops.com.ai/toolhive" = "labeled-toolhive"
                            team = "ai-platform"
                            environment = "staging"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 3: Custom namespace is respected
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-namespace"
        spec = {
            compositionPath = "apis/toolhives/composition.yaml"
            xrdPath = "apis/toolhives/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "ToolHive"
                metadata.name = "ns-test"
                spec = {
                    clusterName = "test-cluster"
                    namespace = "mcp-servers"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "ns-test"
                    spec.forProvider.namespace = "mcp-servers"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 4: OCI helm repository is used
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "oci-helm-repository"
        spec = {
            compositionPath = "apis/toolhives/composition.yaml"
            xrdPath = "apis/toolhives/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "ToolHive"
                metadata.name = "repo-test"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "repo-test"
                    spec.forProvider.chart = {
                        name = "toolhive-operator"
                        repository = "oci://ghcr.io/stacklok/toolhive"
                        version = "0.5.6"
                    }
                }
            ]
        }
    }
]

items = _items
