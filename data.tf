/* data "aws_ebs_volume" "ebs_volume" {
  #most_recent = true
  
  filter {
    name   = "volume-type"
    values = ["gp2"]
  }
  filter {
     name = "status"
     values = ["available"]
  }

}

data "aws_instances" "test" {
  
    instance_state_names = ["running", "stopped"]
}

output "dataoutput" {
  value = "volume id:${data.aws_ebs_volume.ebs_volume.id}"
    
}

output "dataoutput1" {
    value=data.aws_instances.test.ids[0]
} */