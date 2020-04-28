# Global

variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

# SignalFx module specific

variable "notifications" {
  description = "Notification recipients list for every detectors"
  type        = list
}

variable "prefixes" {
  description = "Prefixes list to prepend between brackets on every monitors names before environment"
  type        = list
  default     = []
}

variable "filter_custom_includes" {
  description = "List of tags to include when custom filtering is used"
  type        = list
  default     = []
}

variable "filter_custom_excludes" {
  description = "List of tags to exclude when custom filtering is used"
  type        = list
  default     = []
}

variable "detectors_disabled" {
  description = "Disable all detectors in this module"
  type        = bool
  default     = false
}

# GCP PubSub subscription detectors specific

variable "heartbeat_disabled" {
  description = "Disable all alerting rules for heartbeat detector"
  type        = bool
  default     = null
}

variable "heartbeat_notifications" {
  description = "Notification recipients list for every alerting rules of heartbeat detector"
  type        = list
  default     = []
}

variable "heartbeat_timeframe" {
  description = "Timeframe for system not reporting detector (i.e. \"10m\")"
  type        = string
  default     = "20m"
}

# Oldest_unacked_message detectors

variable "oldest_unacked_message_disabled" {
  description = "Disable all alerting rules for oldest_unacked_message detector"
  type        = bool
  default     = null
}

variable "oldest_unacked_message_disabled_critical" {
  description = "Disable critical alerting rule for oldest_unacked_message detector"
  type        = bool
  default     = null
}

variable "oldest_unacked_message_disabled_warning" {
  description = "Disable warning alerting rule for oldest_unacked_message detector"
  type        = bool
  default     = null
}

variable "oldest_unacked_message_notifications" {
  description = "Notification recipients list for every alerting rules of oldest_unacked_message detector"
  type        = list
  default     = []
}

variable "oldest_unacked_message_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of oldest_unacked_message detector"
  type        = list
  default     = []
}

variable "oldest_unacked_message_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of oldest_unacked_message detector"
  type        = list
  default     = []
}

variable "oldest_unacked_message_aggregation_function" {
  description = "Aggregation function and group by for oldest_unacked_message detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean(by=['subscription_id'])"
}

variable "oldest_unacked_message_transformation_function" {
  description = "Transformation function for oldest_unacked_message detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "oldest_unacked_message_transformation_window" {
  description = "Transformation window for oldest_unacked_message detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "oldest_unacked_message_threshold_critical" {
  description = "Critical threshold for oldest_unacked_message detector"
  type        = number
  default     = 120
}

variable "oldest_unacked_message_threshold_warning" {
  description = "Warning threshold for oldest_unacked_message detector"
  type        = number
  default     = 30
}

# Push_latency detectors

variable "push_latency_disabled" {
  description = "Disable all alerting rules for push_latency detector"
  type        = bool
  default     = null
}

variable "push_latency_disabled_critical" {
  description = "Disable critical alerting rule for push_latency detector"
  type        = bool
  default     = null
}

variable "push_latency_disabled_warning" {
  description = "Disable warning alerting rule for push_latency detector"
  type        = bool
  default     = null
}

variable "push_latency_notifications" {
  description = "Notification recipients list for every alerting rules of push_latency detector"
  type        = list
  default     = []
}

variable "push_latency_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of push_latency detector"
  type        = list
  default     = []
}

variable "push_latency_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of push_latency detector"
  type        = list
  default     = []
}

variable "push_latency_aggregation_function" {
  description = "Aggregation function and group by for push_latency detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean(by=['subscription_id'])"
}

variable "push_latency_transformation_function" {
  description = "Transformation function for push_latency detector (mean, min, max)"
  type        = string
  default     = "mean"
}

variable "push_latency_transformation_window" {
  description = "Transformation window for push_latency detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "10m"
}

variable "push_latency_threshold_critical" {
  description = "Critical threshold for push_latency detector"
  type        = number
  default     = 5000
}

variable "push_latency_threshold_warning" {
  description = "Warning threshold for push_latency detector"
  type        = number
  default     = 1000
}

# Push_latency_anomaly detectors

variable "push_latency_anomaly_disabled" {
  description = "Disable all alerting rules for push_latency_anomaly detector"
  type        = bool
  default     = null
}

variable "push_latency_anomaly_disabled_critical" {
  description = "Disable critical alerting rule for push_latency_anomaly detector"
  type        = bool
  default     = null
}

variable "push_latency_anomaly_notifications" {
  description = "Notification recipients list for every alerting rules of push_latency_anomaly detector"
  type        = list
  default     = []
}

variable "push_latency_anomaly_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of push_latency_anomaly detector"
  type        = list
  default     = []
}

variable "push_latency_anomaly_aggregation_function" {
  description = "Aggregation function and group by for push_latency_anomaly detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean(by=['subscription_id'])"
}

variable "push_latency_anomaly_transformation_function" {
  description = "Transformation function for push_latency_anomaly detector (mean, min, max)"
  type        = string
  default     = "mean"
}

variable "push_latency_anomaly_transformation_window" {
  description = "Transformation window for push_latency_anomaly detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "10m"
}

variable "push_latency_anomaly_threshold_critical" {
  description = "Critical threshold for push_latency_anomaly detector"
  type        = number
  default     = 2
}

variable "push_latency_anomaly_current_window" {
  description = "Window being tested for anomalous values"
  type        = string
  default     = "5m"
}

variable "push_latency_anomaly_historical_window" {
  description = "Window that defines normal values"
  type        = string
  default     = "1h"
}

variable "push_latency_anomaly_fire_num_stddev" {
  description = "Number of standard deviations different from historical mean required to trigger, should be >= 0"
  type        = number
  default     = 3
}

variable "push_latency_anomaly_clear_num_stddev" {
  description = "Number of standard deviations different from historical mean required to clear, should be >= 0"
  type        = number
  default     = 2.5
}

variable "push_latency_anomaly_orientation" {
  description = "Specifies whether detect fires when signal is above, below, or out-of-band (options: above, below, out_of_band)"
  type        = string
  default     = "above"
}

variable "push_latency_anomaly_calculation_mode" {
  description = "Specifies whether to use exponentially weighted or usual moving average (options: vanilla, ewma)"
  type        = string
  default     = "vanilla"
}
