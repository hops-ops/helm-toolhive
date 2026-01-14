import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# E2E tests for ToolHive XRD
#
# These tests verify actual deployment of ToolHive operator to a Kubernetes cluster.
# ==============================================================================

_items = [
    metav1alpha1.CompositionTest {
        metadata.name = "e2e-toolhive-deployment"
        spec = {
            compositionPath = "apis/toolhives/composition.yaml"
            xrdPath = "apis/toolhives/definition.yaml"
            timeoutSeconds = 300
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "ToolHive"
                metadata.name = "toolhive-e2e"
                spec = {
                    clusterName = "e2e-cluster"
                    namespace = "toolhive-system"
                    providerConfigRef = {
                        name = "e2e-provider"
                        kind = "ProviderConfig"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "toolhive-e2e"
                    spec.forProvider.chart.name = "toolhive-operator"
                    spec.forProvider.namespace = "toolhive-system"
                    spec.providerConfigRef.name = "e2e-provider"
                }
            ]
        }
    }
]

items = _items
