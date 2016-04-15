#!/bin/bash
#cd /export/apiserver.local.unsecure && find . -name "*.sh" -exec sed -i -e "s#\(wget.*\)#\1 2>/dev/null#"  {} +
cd /export/apiserver.local.unsecure && find . -name "*.sh" -exec sed -i -e "s/#wget/wget/"  {} +
