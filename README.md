# Kubernetes on Google Computing Engine

This project leverages hype tools 😉 (terraform 🏗, ansible 🛠, docker 🐳, ...) 
to automate the deployment of a 6 vms (3 controllers 👩‍✈️, 3 workers 👷‍) 
kubernetes cluster on GCE.

## How to use 🗺

- Put your `adc.json` in the `app` dir.
- Launch `./in.sh`, it will build a docker image and launch a container with
all needed tools
- In the container `cd app` and `./create.sh` and wait for ~10mins
- And you're done ! 🚀

🚽 When you finish, launch `./cleanup.sh` to remove all gce resources.

## Credits 👍

This work is an automation of [kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
