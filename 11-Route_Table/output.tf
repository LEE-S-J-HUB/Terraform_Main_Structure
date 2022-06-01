output "rt_id" {
    value = { for k,rt in module.RouteTable.rts : k => rt.id }
}


output "rtrs" {
    value = module.RouteTable.rtrs
}