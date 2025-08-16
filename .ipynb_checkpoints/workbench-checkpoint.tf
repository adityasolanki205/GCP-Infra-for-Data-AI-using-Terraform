/*
resource "google_workbench_instance" "default" {
  name     = "workbench-instance"
  location = "asia-south1-a"

  gce_setup {
    machine_type = "e2-standard-4"
    vm_image {
      project = "cloud-notebooks-managed"
      family  = "workbench-instances"
    }
  }
}
*/