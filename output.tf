output "AdresseIP"{
    value = aws_instance.ServeurWeb.public_ip
}
output "ZoneDispo"{
    value = aws_instance.ServeurWeb.availability_zone
}

output "AvZone"{
   value =  data.aws_availability_zones.available.names[1]
}