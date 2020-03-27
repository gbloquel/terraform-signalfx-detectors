output "heartbeat_id" {
  description = "id for detector heartbeat"
  value       = signalfx_detector.heartbeat.*.id
}

output "mysql_slow_id" {
  description = "id for detector mysql_slow"
  value       = signalfx_detector.mysql_slow.*.id
}
