# Kubernetes on Google Computing Engine

This project leverages hype tools 😉 (terraform 🏗, ansible 🛠, docker 🐳, ...) 
to automate the deployment of a 6 vms (3 controllers 👩‍✈️, 3 workers 👷‍) 
kubernetes cluster on GCE.

## How to use 🗺

- Put your `adc.json` in the `app` dir (See [Gcloud account](#gcloud-account) for details on this file) .
- Adapt `profile` to match your desired region, zone and project
- Launch `./in.sh`, it will build a docker image and launch a container with
all needed tools
- In the container `cd app` and `./create.sh` and wait for ~10mins
- And you're done ! 🚀

🚽 When you finish, launch `./cleanup.sh` to remove all gce resources.

## Gcloud account 

To interact with Gcloud API we use a service account. 
The `adc.json` is your service account key file.
You can find more infos on how to setup a service account 
[here](https://cloud.google.com/video-intelligence/docs/common/auth#set_up_a_service_account).

## Credits 👍

This work is an automation of [kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
