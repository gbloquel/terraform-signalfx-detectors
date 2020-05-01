resource "signalfx_detector" "replica_available" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes workload available replicas"

	program_text = <<-EOF
		A = data('kubernetes.deployment.desired' and ${module.filter-tags.filter_custom})${var.replica_available_aggregation_function}
		B = data('kubernetes.deployment.available' and ${module.filter-tags.filter_custom})${var.replica_available_aggregation_function}
		signal = (A-B).${var.replica_available_transformation_function}(over='${var.replica_available_transformation_window}').publish('signal')
		detect(when(signal < ${var.replica_available_threshold_critical}) and when(B < ${var.replica_available_threshold_number_requests})).publish('CRIT')
		detect(when(signal < ${var.replica_available_threshold_warning}) and when(B < ${var.replica_available_threshold_number_requests}) and when(signal >= ${var.replica_available_threshold_critical})).publish('WARN')

	EOF

	rule {
		description           = "are too low < ${var.replica_available_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.replica_available_disabled_critical, var.replica_available_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.replica_available_notifications_critical, var.replica_available_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "are too low < ${var.replica_available_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.replica_available_disabled_warning, var.replica_available_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.replica_available_notifications_warning, var.replica_available_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "replica_ready" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes workload ready replicas"

	program_text = <<-EOF
		A = data('kubernetes.replica_set.desired' and ${module.filter-tags.filter_custom})${var.replica_ready_aggregation_function}
		B = data('kubernetes.replica_set.available' and ${module.filter-tags.filter_custom})${var.replica_ready_aggregation_function}
		signal = (A-B).${var.replica_ready_transformation_function}(over='${var.replica_ready_transformation_window}').publish('signal')
		detect(when(signal < ${var.replica_ready_threshold_critical}) and when(B < ${var.replica_ready_threshold_number_requests})).publish('CRIT')
		detect(when(signal < ${var.replica_ready_threshold_warning}) and when(B < ${var.replica_ready_threshold_number_requests}) and when(signal >= ${var.replica_ready_threshold_critical})).publish('WARN')

	EOF

	rule {
		description           = "are too low < ${var.replica_ready_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.replica_ready_disabled_critical, var.replica_ready_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.replica_ready_notifications_critical, var.replica_ready_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "are too low < ${var.replica_ready_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.replica_ready_disabled_warning, var.replica_ready_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.replica_ready_notifications_warning, var.replica_ready_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}