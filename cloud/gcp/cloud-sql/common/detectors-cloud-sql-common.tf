resource "signalfx_detector" "heartbeat" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('database/cpu/usage_time' and ${module.filter-tags.filter_custom}).publish('signal')
		not_reporting.detector(stream=signal, resource_identifier=['database_id'], duration='${var.heartbeat_timeframe}').publish('CRIT')
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

resource "signalfx_detector" "cpu_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL CPU utilization"

	program_text = <<-EOF
		A = data('database/cpu/utilization' and ${module.filter-tags.filter_custom})${var.cpu_utilization_aggregation_function}
		signal = (A*100).${var.cpu_utilization_transformation_function}(over='${var.cpu_utilization_transformation_window}').publish('signal')
		detect(when(signal > ${var.cpu_utilization_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.cpu_utilization_threshold_warning}) and when(signal <= ${var.cpu_utilization_threshold_critical})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.cpu_utilization_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.cpu_utilization_disabled_critical, var.cpu_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.cpu_utilization_notifications_critical, var.cpu_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.cpu_utilization_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.cpu_utilization_disabled_warning, var.cpu_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.cpu_utilization_notifications_warning, var.cpu_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "disk_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL disk utilization"

	program_text = <<-EOF
		A = data('database/disk/utilization' and ${module.filter-tags.filter_custom})${var.disk_utilization_aggregation_function}
		signal = (A*100).${var.disk_utilization_transformation_function}(over='${var.disk_utilization_transformation_window}').publish('signal')
		detect(when(signal > ${var.disk_utilization_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.disk_utilization_threshold_warning}) and when(signal <= ${var.disk_utilization_threshold_critical})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.disk_utilization_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.disk_utilization_disabled_critical, var.disk_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.disk_utilization_notifications_critical, var.disk_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.disk_utilization_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.disk_utilization_disabled_warning, var.disk_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.disk_utilization_notifications_warning, var.disk_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "disk_utilization_forecast" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL disk space is running out"

	program_text = <<-EOF
		from signalfx.detectors.countdown import countdown
		signal = data('database/disk/utilization', filter=${module.filter-tags.filter_custom}).publish('signal')
		countdown.hours_left_stream_incr_detector(stream=signal, maximum_capacity=${var.disk_utilization_forecast_maximum_capacity}, lower_threshold=${var.disk_utilization_forecast_hours_till_full}, fire_lasting=lasting('${var.disk_utilization_forecast_fire_lasting_time}', ${var.disk_utilization_forecast_fire_lasting_time_percent}), clear_threshold=${var.disk_utilization_forecast_clear_hours_remaining}, clear_lasting=lasting('${var.disk_utilization_forecast_clear_lasting_time}', ${var.disk_utilization_forecast_clear_lasting_time_percent}), use_double_ewma=${var.disk_utilization_forecast_use_ewma}).publish('CRIT')
	EOF

	rule {
		description           = "in ${var.disk_utilization_forecast_hours_till_full}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.disk_utilization_forecast_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.disk_utilization_forecast_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "memory_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL memory utilization"

	program_text = <<-EOF
		A = data('database/memory/utilization' and ${module.filter-tags.filter_custom})${var.memory_utilization_aggregation_function}
		signal = (A*100).${var.memory_utilization_transformation_function}(over='${var.memory_utilization_transformation_window}').publish('signal')
		detect(when(signal > ${var.memory_utilization_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.memory_utilization_threshold_warning}) and when(signal <= ${var.memory_utilization_threshold_critical})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.memory_utilization_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.memory_utilization_disabled_critical, var.memory_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_utilization_notifications_critical, var.memory_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.memory_utilization_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.memory_utilization_disabled_warning, var.memory_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_utilization_notifications_warning, var.memory_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "memory_utilization_forecast" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL memory is running out"

	program_text = <<-EOF
		from signalfx.detectors.countdown import countdown
		signal = data('database/memory/utilization', filter=${module.filter-tags.filter_custom}).publish('signal')
		countdown.hours_left_stream_incr_detector(stream=signal, maximum_capacity=${var.memory_utilization_forecast_maximum_capacity}, lower_threshold=${var.memory_utilization_forecast_hours_till_full}, fire_lasting=lasting('${var.memory_utilization_forecast_fire_lasting_time}', ${var.memory_utilization_forecast_fire_lasting_time_percent}), clear_threshold=${var.memory_utilization_forecast_clear_hours_remaining}, clear_lasting=lasting('${var.memory_utilization_forecast_clear_lasting_time}', ${var.memory_utilization_forecast_clear_lasting_time_percent}), use_double_ewma=${var.memory_utilization_forecast_use_ewma}).publish('CRIT')
	EOF

	rule {
		description           = "in ${var.memory_utilization_forecast_hours_till_full}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.memory_utilization_forecast_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_utilization_forecast_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "failover_unavailable" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP Cloud SQL failover unavailable"

	program_text = <<-EOF
		signal = data('database/available_for_failover' and ${module.filter-tags.filter_custom})${var.failover_unavailable_aggregation_function}.${var.failover_unavailable_transformation_function}(over='${var.failover_unavailable_transformation_window}').publish('signal')
		detect(when(signal <= ${var.failover_unavailable_threshold_critical})).publish('CRIT')
		detect(when(signal <= ${var.failover_unavailable_threshold_warning}) and when(signal > ${var.failover_unavailable_threshold_critical})).publish('WARN')
	EOF

	rule {
		description           = "is too low <= ${var.failover_unavailable_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.failover_unavailable_disabled_critical, var.failover_unavailable_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.failover_unavailable_notifications_critical, var.failover_unavailable_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too low <= ${var.failover_unavailable_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.failover_unavailable_disabled_warning, var.failover_unavailable_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.failover_unavailable_notifications_warning, var.failover_unavailable_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}
