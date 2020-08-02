#!/bin/bash

sudo cp ./SwapMBPAltSuper.service /etc/systemd/system/SwapMBPAltSuper.service
sudo systemctl daemon-reload
sudo systemctl enable SwapMBPAltSuper
