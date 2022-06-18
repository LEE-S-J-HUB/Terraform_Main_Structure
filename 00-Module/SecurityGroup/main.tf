resource "aws_security_group" "this" {
    for_each            = { for sg in var.scg : sg.identifier => sg }
    vpc_id              = each.value.vpc_id
    name                = each.value.tags["Name"]
    tags                = each.value.tags
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}