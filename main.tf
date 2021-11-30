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
        inspect_template_name = google_data_loss_prevention_inspect_template.basic.id
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
<<<<<<< HEAD

resource "google_data_loss_prevention_inspect_template" "basic" {
    parent = "airline1-sabre-wolverine"
    description = "My description"
    display_name = "display_name"

    inspect_config {
        info_types {
            name = "EMAIL_ADDRESS"
        }
        info_types {
            name = "PERSON_NAME"
        }
        info_types {
            name = "LAST_NAME"
        }
        info_types {
            name = "DOMAIN_NAME"
        }
        info_types {
            name = "PHONE_NUMBER"
        }
        info_types {
            name = "FIRST_NAME"
        }

        min_likelihood = "UNLIKELY"
        rule_set {
            info_types {
                name = "EMAIL_ADDRESS"
            }
            rules {
                exclusion_rule {
                    regex {
                        pattern = ".+@example.com"
                    }
                    matching_type = "MATCHING_TYPE_FULL_MATCH"
                }
            }
        }
        rule_set {
            info_types {
                name = "EMAIL_ADDRESS"
            }
            info_types {
                name = "DOMAIN_NAME"
            }
            info_types {
                name = "PHONE_NUMBER"
            }
            info_types {
                name = "PERSON_NAME"
            }
            info_types {
                name = "FIRST_NAME"
            }
            rules {
                exclusion_rule {
                    dictionary {
                        word_list {
                            words = ["TEST"]
                        }
                    }
                    matching_type = "MATCHING_TYPE_PARTIAL_MATCH"
                }
            }
        }

        rule_set {
            info_types {
                name = "PERSON_NAME"
            }
            rules {
                hotword_rule {
                    hotword_regex {
                        pattern = "patient"
                    }
                    proximity {
                        window_before = 50
                    }
                    likelihood_adjustment {
                        fixed_likelihood = "VERY_LIKELY"
                    }
                }
            }
        }

        limits {
            max_findings_per_item    = 10
            max_findings_per_request = 50
            max_findings_per_info_type {
                max_findings = "75"
                info_type {
                    name = "PERSON_NAME"
                }
            }
            max_findings_per_info_type {
                max_findings = "80"
                info_type {
                    name = "LAST_NAME"
                }
            }
        }
    }
}
