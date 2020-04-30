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

# MySQL detectors specific

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

# Mysql_slow detectors

variable "mysql_slow_disabled" {
  description = "Disable all alerting rules for mysql_slow detector"
  type        = bool
  default     = null
}

variable "mysql_slow_disabled_critical" {
  description = "Disable critical alerting rule for mysql_slow detector"
  type        = bool
  default     = null
}

variable "mysql_slow_disabled_warning" {
  description = "Disable warning alerting rule for mysql_slow detector"
  type        = bool
  default     = null
}

variable "mysql_slow_notifications" {
  description = "Notification recipients list for every alerting rules of mysql_slow detector"
  type        = list
  default     = []
}

variable "mysql_slow_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of mysql_slow detector"
  type        = list
  default     = []
}

variable "mysql_slow_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of mysql_slow detector"
  type        = list
  default     = []
}

variable "mysql_slow_aggregation_function" {
  description = "Aggregation function and group by for mysql_slow detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "mysql_slow_transformation_function" {
  description = "Transformation function for mysql_slow detector (mean, min, max)"
  type        = string
  default     = "mean"
}

variable "mysql_slow_transformation_window" {
  description = "Transformation window for mysql_slow detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "15m"
}

variable "mysql_slow_threshold_critical" {
  description = "Critical threshold for mysql_slow detector"
  type        = number
  default     = 20
}

variable "mysql_slow_threshold_warning" {
  description = "Warning threshold for mysql_slow detector"
  type        = number
  default     = 5
}
