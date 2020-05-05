resource "signalfx_detector" "heartbeat" {
 	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] PostgreSQL heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('postgres_database_size', filter=filter('plugin', 'postgresql') and ${module.filter-tags.filter_custom})
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

resource "signalfx_detector" "too_many_locks" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] PostgreSQL number of locks"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		signal = data('postgres_deadlocks', filter=filter('plugin', 'postgresql')) and ${module.filter-tags.filter_custom})${var.too_many_locks_aggregation_function}.${var.too_many_locks_transformation_function}(over='${var.too_many_locks_transformation_window}').publish('signal')
		aperiodic.above_or_below_detector(signal, ${var.too_many_locks_threshold_critical}, 'above', lasting('${var.too_many_locks_aperiodic_duration}', ${var.too_many_locks_aperiodic_percentage})).publish('CRIT')
		aperiodic.range_detector(signal, ${var.too_many_locks_threshold_warning}, ${var.too_many_locks_threshold_critical}, 'within_range', lasting('${var.too_many_locks_aperiodic_duration}', ${var.too_many_locks_aperiodic_percentage}), upper_strict=False).publish('WARN')
	EOF

	rule {
		description           = "are too high > ${var.too_many_locks_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.too_many_locks_disabled_critical, var.too_many_locks_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_many_locks_notifications_critical, var.too_many_locks_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "are too high > ${var.too_many_locks_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.too_many_locks_disabled_warning, var.too_many_locks_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_many_locks_notifications_warning, var.too_many_locks_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}
