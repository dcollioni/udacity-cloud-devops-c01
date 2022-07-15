# Packer Instructions

## Pre-requisite Azure Resources

1. Create a Resource Group named `packer-rg`
1. Create an App Registration named `packer`
1. Give the `packer` app `Contributor` access to the `packer-rg` group

## Build Image

1. Go to the [`/packer`](packer) folder

1. Create a `dev.pkrvars.json` file inside the folder with the following variables:

    ```json
    {
      "client_id": "",
      "client_secret": "",
      "subscription_id": ""
    }
    ```

1. Update the variable values with your `packer` app client ID, client secret and your Azure subscription ID

1. Build the image by running:

    ```sh
    packer build -var-file=dev.pkrvars.json ./image.json
    ```

1. List the created image by running:

    ```sh
    az image list -o table -g packer-rg
    ```

## Delete Image

1. To delete the image, run:

    ```sh
    az image delete -n c01-image -g packer-rg
    ```
