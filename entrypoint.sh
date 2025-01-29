#!/bin/bash

# Check if /notebooks_tmp exists
if [ -d "/notebooks_tmp" ]; then
    # Move all contents from /notebooks_tmp to /notebooks
    mv /notebooks_tmp/* /notebooks/
    # Remove /notebooks_tmp directory
    rm -rf /notebooks_tmp
fi


# Execute the CMD passed as arguments
exec "$@"
