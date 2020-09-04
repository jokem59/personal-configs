# Setup
# https://github.com/patjak/bcwc_pcie/wiki/Get-Started#devvideo-not-created

firmware_dir="facetime-firmware"
bcwc_dir="bcwc_pcie"

echo -e Step 1: Firmware Extraction\n

if [ -d "/tmp/$firmware_dir" ]; then
    echo -e /tmp/$facetime_dir already exists!  Deleting...\n
    rm /tmp/facetime-firmware -rf
fi

git clone https://github.com/patjak/facetimehd-firmware.git /tmp/$firmware_dir

pushd /tmp/$firmware_dir
make
sudo make install

popd

echo -e \nStep 2: Installing the Driver\n

if [ -d "/tmp/$bcwc_dir" ]; then
    echo -e /tmp/$bcwc_dir already exists!  Deleting...\n
    rm /tmp/$bcwc_dir -rf
fi

git clone https://github.com/patjak/bcwc_pcie.git /tmp/$bcwc_dir

pushd /tmp/$bcwc_dir/firmware

printf "Compiling firmware\n";
make
printf "done\n\n";

printf "Installing firmware\n";
sudo make install
printf "done\n\n";

cd ..

printf "Compiling driver\n";
make
printf "done\n\n";

printf "Installing driver\n";
sudo make install
printf "done\n\n";

printf "Running depmod\n";
sudo depmod
printf "done\n\n";

printf "Running modprobe -r bdc_pci\n";
sudo modprobe -r bdc_pci
printf "done\n\n";

printf "Loading driver\n";
sudo modprobe facetimehd
printf "done\n\n";

popd

# If sudo modprobe facetimehd fails, run dmesg. If you get facetimehd: version magic '4.13.0-37-generic SMP mod_unload ' should be
# '4.13.0-38-generic SMP mod_unload ', or similar, you may manually edit the file via sudo vim
# /lib/modules/4.13.0-38-generic/extra/facetimehd.ko and replace vermagic=4.13.0-37-generic SMP mod_unload with vermagic=4.13.0-38-generic
# SMP mod_unload. Then you may be able to sudo modprobe facetimehd without any issues.

# Load module on startup
echo facetimehd >> /etc/modules
