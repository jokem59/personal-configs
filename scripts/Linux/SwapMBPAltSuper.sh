#!/bin/bash

sudo sed 's/0/1/' /sys/module/hid_apple/parameters/swap_opt_cmd | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd
