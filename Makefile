# Change the configuration here.
# Include your useid/name as part of IMAGENAME to avoid conflicts
IMAGENAME = docker-imagesim
CONFIG    = imagesim
COMMAND   = bash
DISKS     = -v $(PWD):/project
USERID    = $(shell id -u)
GROUPID   = $(shell id -g)
USERNAME  = $(shell whoami)
PORT      = -p 8888:8888
RUNTIME   =
NETWORK   = --network host
# --runtime=nvidia 
# No need to change anything below this line

# Allows you to use sshfs to mount disks
SSHFSOPTIONS = --cap-add SYS_ADMIN --device /dev/fuse

USERCONFIG   = --build-arg user=$(USERNAME) --build-arg uid=$(USERID) --build-arg gid=$(GROUPID)

.PHONY: .docker simulate data

.docker: docker/Dockerfile-$(CONFIG)
	docker build $(USERCONFIG) $(NETWORK) -t $(USERNAME)-$(IMAGENAME) -f docker/Dockerfile-$(CONFIG) docker

# Using -it for interactive use
RUNCMD=docker run $(RUNTIME) $(NETWORK) --rm --user $(USERID):$(GROUPID) $(PORT) $(SSHFSOPTIONS) $(DISKS) -it $(USERNAME)-$(IMAGENAME)

# Replace 'bash' with the command you want to do
default: .docker
	$(RUNCMD) $(COMMAND)

simulate: .docker data imagesim.sh
	$(RUNCMD) ./imagesim.sh

data: .docker fishDatasetSimulationAlgo

fishDatasetSimulationAlgo: fishDatasetSimulationAlgo.zip
	$(RUNCMD) unzip $<

fishDatasetSimulationAlgo.zip:
	$(RUNCMD) wget ftp://ftp.nmdc.no/nmdc/IMR/MachineLearning/fishDatasetSimulationAlgo.zip

# requires CONFIG=jupyter
jupyter:
	$(RUNCMD) jupyter notebook --ip '$(hostname -I)' --port 8888
