resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "example" {
  metadata {
    name = "my-config"
  }

  data = {
    api_host             = "myhost:443"
    db_host              = "dbhost:5432"
    "my_config_file.yml" = "${file("${path.module}/artifacts/config.yml")}"
  }

  binary_data = {
    "my_payload.bin" = "${filebase64("${path.module}/artifacts/my_payload.bin")}"
  }
}