resource "aws_ecr_repository" "patient_service" {
  name = var.patient_service_repo_name
}

resource "aws_ecr_repository" "appointment_service" {
  name = var.appointment_service_repo_name
}
