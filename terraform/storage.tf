# =============================================================================
# KUBERNETES STORAGE CONFIGURATION
# =============================================================================

# 1. નવી EBS SC બનાવો અને તેને Default સેટ કરો
resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = "ebs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.eks.amazonaws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"

  parameters = {
    type      = "gp3"
    fsType    = "ext4"
    encrypted = "true"
  }

  depends_on = [module.retail_app_eks]
}

# 2. જૂની gp2 સ્ટોરેજ ક્લાસમાંથી Default ટેગ કાઢી નાખો (વગર કોઈ કમાન્ડ રન કર્યે)
resource "kubernetes_annotations" "disable_gp2_default" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "gp2"
  }

  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }

  force = true # આ ખૂબ મહત્વનું છે, તે જૂની વેલ્યુને ઓવરરાઈટ કરશે

  depends_on = [kubernetes_storage_class_v1.ebs_sc]
}