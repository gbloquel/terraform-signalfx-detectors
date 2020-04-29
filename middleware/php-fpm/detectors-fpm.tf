resource "signalfx_detector" "heartbeat" {
 	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] PHP-FPM heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('phpfpm_requests' and ${module.filter-tags.filter_custom})
		not_reporting.detector(stream=signal, resource_identifier=['host'], duration='${var.heartbeat_timeframe}').publish('CRIT')
	EOF

	rule {
		description           = "has not reported in ${var.heartbeat_timeframe}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.heartbeat_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.heartbeat_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "php_fpm_connect_idle" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] PHP-FPM active worker"

	program_text = <<-EOF
		A = data('phpfpm_processes.active' and ${module.filter-tags.filter_custom})${var.php_fpm_connect_idle_aggregation_function}
		B = data('phpfpm_processes.total' and ${module.filter-tags.filter_custom})${var.php_fpm_connect_idle_aggregation_function}
		signal = ((A/B)*100).${var.php_fpm_connect_idle_transformation_function}(over='${var.php_fpm_connect_idle_transformation_window}').publish('signal')
		detect(when(signal > ${var.php_fpm_connect_idle_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.php_fpm_connect_idle_threshold_warning}) AND when(signal <= ${var.php_fpm_connect_idle_threshold_critical})).publish('WARN')
	EOF

	rule {
		description           = "are too high > ${var.php_fpm_connect_idle_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.php_fpm_connect_idle_disabled_critical, var.php_fpm_connect_idle_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.php_fpm_connect_idle_notifications_critical, var.php_fpm_connect_idle_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "are too high > ${var.php_fpm_connect_idle_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.php_fpm_connect_idle_disabled_warning, var.php_fpm_connect_idle_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.php_fpm_connect_idle_notifications_warning, var.php_fpm_connect_idle_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}