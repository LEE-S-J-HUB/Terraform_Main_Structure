locals {
    project_code            = "tra01"
    Environment             = "DEV"
    tags                    = {
        "TargetGroup"   = {
            "Name"  = lower(format("tg-an2-%s-%s", local.project_code, local.Environment))
        }
        "vpc"   = {
            "Name"  = lower(format("vpc-an2-%s-%s", local.project_code, local.Environment))
        }
        "ec2"   = {
            "Name"  = lower(format("ec2-an2-%s-%s", local.project_code, local.Environment))
        }
        "eip"   = {
            "Name"  = ""
        }
    }
    vpc_ids = data.terraform_remote_state.VPC_Subnet.outputs.vpc_ids
    ec2_ids = data.terraform_remote_state.EC2.outputs.ec2_instaces_ids
}

resource "aws_lb_target_group" "ip-example" {
  name        = format("${local.tags["TargetGroup"].Name}-%s", "web")
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = local.vpc_ids["${format("${local.tags["vpc"].Name}-%s", "pub")}"]
}

locals {
    tg_arn = aws_lb_target_group.ip-example.arn
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = local.tg_arn
  target_id        = local.ec2_ids[format("${local.tags["ec2"].Name}-%s", "web")] 
  port             = 80
}
