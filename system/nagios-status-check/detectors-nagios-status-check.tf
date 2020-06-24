resource "signalfx_detector" "status_check" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Custom script status"

  program_text = <<-EOF
        signal = data('gauge.status', filter=filter('plugin', 'nagios') and ${module.filter-tags.filter_custom})${var.status_check_aggregation_function}.${var.status_check_transformation_function}(over='${var.status_check_transformation_window}').publish('signal')
        detect(when(signal >= threshold(1)) and when(signal < 2)).publish('WARN')
        detect(when(signal >= threshold(2))).publish('CRIT')
  EOF

  rule {
    description           = "is not OK, please check the script output on the host"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.status_check_disabled_critical, var.status_check_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.status_check_notifications_critical, var.status_check_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is not OK, please check the script output on the host"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.status_check_disabled_warning, var.status_check_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.status_check_notifications_warning, var.status_check_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}
