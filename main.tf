provider "google" {
 # credentials = file("../dialogflow.json")
}

resource "google_dialogflow_cx_agent" "full_agent" {
  display_name               = "us-prod-df-app01-dfagent01"
  location                   = "asia-south1"
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
  
  #security_settings = "projects/airline1-sabre-wolverine/locations/global/securitySettings/ac8dd1d1a8500fe9"
}

