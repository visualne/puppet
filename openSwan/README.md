# openSwan

#### Table of Contents

1. [Overview](#overview)

## Overview

This module installs OpenSwan using tunnel parameters that you specify in the
variables section. I used this on AWS using a RHEL 6.5 AMI. You also need to disable Source/Dest check on the VM that this is deployed on and change the routing table appropriatly in the vpc. Refer to this article here: https://aws.amazon.com/articles/5472675506466066
