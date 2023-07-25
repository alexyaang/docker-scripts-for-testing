#!/bin/bash

# Function to create dangling containers, images, volumes, and networks
create_dangling() {
    echo "Creating dangling containers..."
    docker run -d --name dangling_container_1 busybox sleep 3600
    docker run -d --name dangling_container_2 busybox sleep 3600

    echo "Stopping dangling containers..."
    docker stop dangling_container_1 dangling_container_2

    echo "Creating dangling images..."
    docker run -d --name dangling_image_container_1 busybox sleep 3600
    docker commit dangling_image_container_1 dangling_image_1_tag

    echo "Creating dangling volumes..."
    docker volume create dangling_volume_1

    echo "Creating temporary container to attach the volume..."
    docker run -d --name temp_volume_container -v dangling_volume_1:/data busybox sleep 3600

    echo "Stopping and removing the temporary volume container..."
    docker rm -f temp_volume_container

    echo "Creating dangling networks..."
    docker network create dangling_network_1
    docker run -d --name dangling_network_container_1 --network dangling_network_1 busybox sleep 3600

    echo "Stopping and removing dangling network containers..."
    docker rm -f dangling_network_container_1

    echo "Dangling resources created!"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker CLI not found. Please install Docker before running this script."
    exit 1
fi

# Check if the user is running the script with root privileges
if [[ $(id -u) -ne 0 ]]; then
    echo "This script needs to be run with root privileges (e.g., using sudo)."
    exit 1
fi

# Main execution
echo "Running Docker create dangling resources script..."
create_dangling

exit 0