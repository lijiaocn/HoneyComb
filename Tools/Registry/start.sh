#!/bin/bash
docker run --name "HoneyComb-Registry" -e STORAGE_PATH=/export/Data/registry.dat -p 5000:5000 -v /export/Data:/export/Data registry  &
