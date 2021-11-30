provider "google" {}

resource "google_dialogflow_cx_agent" "full_agent" {
  display_name               = "us-dev-abcd-fghi-dialogflowcx-agent1"
  location                   = "global"
  project                    = "airline1-sabre-wolverine"
  default_language_code      = "en"
  supported_language_codes   = ["fr", "de", "es"]
  time_zone                  = "America/New_York"
  description                = "Example description."
  avatar_uri                 = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
  speech_to_text_settings {
    enable_speech_adaptation = true
  }
  security_settings = google_data_loss_prevention_job_trigger.test_dlp.id
  depends_on = [google_data_loss_prevention_job_trigger.test_dlp]
}

resource "google_data_loss_prevention_job_trigger" "test_dlp" {
    parent = "airline1-sabre-wolverine"
    description = "Description"
    display_name = "us-dev-abcd-fghi-dlp1"

    triggers {
        schedule {
            recurrence_period_duration = "86400s"
        }
    }
  
  inspect_job {
        inspect_template_name = "projects/airline1-sabre-wolverine/locations/global/inspectTemplates/test_inspect_template"
        actions {
            save_findings {
                output_config {
                    table {
                        project_id = "airline1-sabre-wolverine"
                        dataset_id = "dlp_demo"
                    }
                }
            }
        }
        storage_config {
            cloud_storage_options {
                file_set {
                    url = "gs://my_bucket_df/"
                }
            }
        }
    }

}
