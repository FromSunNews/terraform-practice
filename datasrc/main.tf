provider "aws" {

}

variable "os_name" {
  type        = string
  description = "Enter the OS name (e.g., ubuntu, amazon_linux, red_hat, microsoft_windows)"
  validation {
    condition     = contains(["ubuntu", "amazon_linux", "red_hat", "microsoft_windows"], var.os_name)
    error_message = "OS name is invalid! OS name must be either 'ubuntu', 'amazon_linux', 'red_hat' or 'microsoft_windows'."
  }
}

variable "os_version" {
  type        = string
  description = "Enter the OS version"

  validation {
    condition = (
      (var.os_name == "ubuntu" && contains(["24.04", "22.04", "20.04"], var.os_version)) ||
      (var.os_name == "amazon_linux" && contains(["2023"], var.os_version)) ||
      (var.os_name == "red_hat" && contains(["8", "7"], var.os_version)) ||
      (var.os_name == "microsoft_windows" && contains(["2022_core_base", "2019_base", "2019_core_base", "2016_base", "2016_core_base"], var.os_version))
    )
    error_message = (
      var.os_name == "ubuntu" ? "Valid versions for Ubuntu are: 24.04, 22.04, 20.04" :
      var.os_name == "amazon_linux" ? "Valid version for Amazon Linux is: 2023" :
      var.os_name == "red_hat" ? "Valid versions for Red Hat are: 8, 7" :
      var.os_name == "microsoft_windows" ? "Valid versions for Microsoft Windows are: 2022_core_base, 2019_base, 2019_core_base, 2016_base, 2016_core_base" : "Invalid OS type"
    )
  }
}

variable "os_architecture" {
  description = "Enter the architecture (e.g., x86 or arm64)"
  validation {
    condition = (
      (var.os_name == "ubuntu" && var.os_version == "24.04" && contains(["x86", "arm64"], var.os_architecture)) ||
      (var.os_name == "ubuntu" && var.os_version == "22.04" && contains(["x86", "arm64"], var.os_architecture)) ||
      (var.os_name == "ubuntu" && var.os_version == "20.04" && contains(["x86"], var.os_architecture)) ||
      (var.os_name == "amazon_linux" && var.os_version == "2023" && contains(["x86", "arm64"], var.os_architecture)) ||
      (var.os_name == "red_hat" && var.os_version == "9" && contains(["x86", "arm64"], var.os_architecture)) ||
      (var.os_name == "red_hat" && var.os_version == "8" && contains(["x86"], var.os_architecture)) ||
      (var.os_name == "microsoft_windows" && contains(["x86"], var.os_architecture))
    )
    error_message = (
      var.os_name == "ubuntu" ? "For Ubuntu 24.04, 22.04 valid architectures are: x86, arm64" :
      var.os_name == "ubuntu" ? "For Ubuntu 20.04 valid architectures are: x86" :
      var.os_name == "amazon_linux" ? "For Amazon Linux 2023, valid architectures are: x86, arm64" :
      var.os_name == "red_hat" ? "For Red Hat 9, valid architecture are: x86, arm64" :
      var.os_name == "red_hat" ? "For Red Hat 8, valid architecture are: x86" :
      var.os_name == "microsoft_windows" ? "For Microsoft Windows, valid architecture is: x86" : "Invalid OS type or version"
    )
  }
}

variable "default_ami" {
  type = map(any)
  default = {
    "ubuntu" = {
      "24.04" = {
        "x86" = {
          ami_id = "ami-05d2438ca66594916"
        }
        "arm64" = {
          ami_id = "ami-0b48860f51bc4313e"
        }
      }
      "22.04" = {
        "x86" = {
          ami_id = "ami-056a29f2eddc40520"
        }
        "arm64" = {
          ami_id = "ami-03af4c483d5709cc8"
        }
      }
      "20.04" = {
        "x86" = {
          ami_id = "ami-08b2c3a9f2695e351"
        }
      }
    },
    "amazon_linux" = {
      "2023" = {
        "x86" = {
          ami_id = "ami-0023481579962abd4"
        }
        "arm64" = {
          ami_id = "ami-03902f3abd3656067"
        }
      }
    },
    "red_hat" = {
      "9" = {
        "x86" = {
          ami_id = "ami-012e764b9ddef07c2"
        }
        "arm64" = {
          ami_id = "ami-04c85d10b16134b5e"
        }
      },
      "8" = {
        "x86" = {
          ami_id = "ami-005722f667c8d84ea"
        }
      }
    },
    "microsoft_windows" = {
      "2022_core_base" = {
        "x86" = {
          ami_id = "ami-0f30addef66336655"
        }
      },
      "2019_base" = {
        "x86" = {
          ami_id = "ami-0dc61271afef7184d"
        }
      },
      "2019_core_base" = {
        "x86" = {
          ami_id = "ami-026fecb9bb2817d44"
        }
      },
      "2016_base" = {
        "x86" = {
          ami_id = "ami-012c0640876552756"
        }
      },
      "2016_core_base" = {
        "x86" = {
          ami_id = "ami-04d00820355471c2d"
        }
      }
    }
  }
}

resource "aws_instance" "instance_tf" {
  ami           = var.default_ami[var.os_name][var.os_version][var.os_architecture].ami_id
  instance_type = "t2.micro"
}

output "check_os_name" {
  value = "You selected OS: ${var.os_name}, Version: ${var.os_version}, Architecture: ${var.os_architecture}"
}
