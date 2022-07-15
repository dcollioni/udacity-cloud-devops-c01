# build a packer image
packer build -var-file=dev.pkrvars.json ./image.json

# list images
az image list -o table -g packer-rg

# delete an image
az image delete -n c01-image -g packer-rg
