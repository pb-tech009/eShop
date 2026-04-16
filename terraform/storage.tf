# =============================================================================
# KUBERNETES STORAGE CONFIGURATION
# =============================================================================

# Define the EBS CSI StorageClass and set it as default
# This ensures that all infrastructure services (Postgres, Redis, RabbitMQ)
# can automatically provision EBS volumes with the correct settings.

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

# Ensure the old gp2 storage class is not the default to prevent conflicts
resource "null_resource" "remove_gp2_default" {
  provisioner "local-exec" {
    command = "kubectl patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}' || true"
  }

  depends_on = [module.retail_app_eks]
}
