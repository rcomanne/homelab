terraform {
  required_providers {
    macaddress = {
      source = "ivoronin/macaddress"
      version = "0.3.2"
    }
  }
}

provider "macaddress" {
  # Configuration options
}

resource "macaddress" "address" {
  count = 5
}

output "mac_address" {
  value = [for address in macaddress.address : upper(address.address)]
}