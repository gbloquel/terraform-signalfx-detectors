resource "signalfx_detector" "heartbeat" {
 	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] MySQL heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('mysql_octets.rx', filter=filter('plugin', 'mysql') and ${module.filter-tags.filter_custom})
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

resource "signalfx_detector" "mysql_slow" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Mysql slow queries rate"

	program_text = <<-EOF
		A = data('mysql_slow_queries', filter=filter('plugin', 'mysql') and ${module.filter-tags.filter_custom})${var.mysql_slow_aggregation_function}
		B = data('threads.running', filter=filter('plugin', 'mysql') and ${module.filter-tags.filter_custom})${var.mysql_slow_aggregation_function}
		signal = (A/B).scale(100).${var.mysql_slow_transformation_function}(over='${var.mysql_slow_transformation_window}')
		detect(when(signal > ${var.mysql_slow_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.mysql_slow_threshold_warning}) and when(signal <= ${var.mysql_slow_threshold_critical})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.mysql_slow_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.mysql_slow_disabled_critical, var.mysql_slow_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.mysql_slow_notifications_critical, var.mysql_slow_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.mysql_slow_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.mysql_slow_disabled_warning, var.mysql_slow_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.mysql_slow_notifications_warning, var.mysql_slow_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "mysql_threads_anomaly" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Mysql threads changed abnormally"

	program_text = <<-EOF
		from signalfx.detectors.against_periods import against_periods
		signal = data('threads.running', filter=filter('plugin', 'mysql') and ${module.filter-tags.filter_custom})${var.mysql_threads_anomaly_aggregation_function}.${var.mysql_threads_anomaly_transformation_function}(over='${var.mysql_threads_anomaly_transformation_window}').publish('signal')
		against_periods.detector_growth_rate(signal, window_to_compare=duration('${var.mysql_threads_anomaly_window_to_compare}'), space_between_windows=duration('${var.mysql_threads_anomaly_space_between_windows}'), num_windows=${var.mysql_threads_anomaly_num_windows}, fire_growth_rate_threshold=${var.mysql_threads_anomaly_fire_growth_rate_threshold}, clear_growth_rate_threshold=${var.mysql_threads_anomaly_clear_growth_rate_threshold}, discard_historical_outliers=${var.mysql_threads_anomaly_discard_historical_outliers}, orientation='${var.mysql_threads_anomaly_orientation}').publish('CRIT')
	EOF

	rule {
		description           = "is too high > ${var.mysql_threads_anomaly_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.mysql_threads_anomaly_disabled_critical, var.mysql_threads_anomaly_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.mysql_threads_anomaly_notifications_critical, var.mysql_threads_anomaly_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "mysql_questions_anomaly" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Elasticsearch number of open HTTP connection anomaly"

	program_text = <<-EOF
		from signalfx.detectors.against_periods import against_periods
		signal = data('mysql_handler.commit', filter=filter('plugin', 'mysql') and ${module.filter-tags.filter_custom})${var.mysql_questions_anomaly_aggregation_function}.${var.mysql_questions_anomaly_transformation_function}(over='${var.mysql_questions_anomaly_transformation_window}').publish('signal')
		against_periods.detector_growth_rate(signal, window_to_compare=duration('${var.mysql_questions_anomaly_window_to_compare}'), space_between_windows=duration('${var.mysql_questions_anomaly_space_between_windows}'), num_windows=${var.mysql_questions_anomaly_num_windows}, fire_growth_rate_threshold=${var.mysql_questions_anomaly_fire_growth_rate_threshold}, clear_growth_rate_threshold=${var.mysql_questions_anomaly_clear_growth_rate_threshold}, discard_historical_outliers=${var.mysql_questions_anomaly_discard_historical_outliers}, orientation='${var.mysql_questions_anomaly_orientation}').publish('CRIT')
	EOF

	rule {
		description           = "is too high > ${var.mysql_questions_anomaly_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.mysql_questions_anomaly_disabled_critical, var.mysql_questions_anomaly_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.mysql_questions_anomaly_notifications_critical, var.mysql_questions_anomaly_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}
