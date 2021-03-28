#!/usr/bin/env bash

# Script variables.
addon_folder="${HOME}/.kodi/addons"
current_file="$(dirname "$(readlink -f "$0")")/$(basename "$0")"
est_settings="${HOME}/.kodi/userdata/addon_data/skin.estuary/settings.xml"
gui_settings="${HOME}/.kodi/userdata/guisettings.xml"
media_folder="$(find /var/media -type d | sort -r | head -1)"
qbt_settings="${HOME}/.opt/etc/qBittorrent_entware/config/qBittorrent.conf"
sources_file="${HOME}/.kodi/userdata/sources.xml"
startup_file="${HOME}/.config/autostart.sh"

# Create the folder tree on the external drive.
if [ "${media_folder}" != "/var/media" ]; then
    mkdir -p "${media_folder}/Albums"
    mkdir -p "${media_folder}/Movies"
    mkdir -p "${media_folder}/Pictures"
    mkdir -p "${media_folder}/Series"
    mkdir -p "${media_folder}/Torrents"
    mkdir -p "${media_folder}/Torrents/Incomplete"
fi

# Install the entware package manager and reboot.
if ! [ -x "$(command -v opkg)" ]; then
    echo "(sleep 10 && /usr/bin/sh ${current_file})&" | tee "${startup_file}"
    installentware
    reboot
    exit 1
fi

# Remove the previously created autostart.sh script.
rm -f "${startup_file}"

# Install the qbittorrent package.
opkg update && opkg upgrade
opkg install qbittorrent

# Edit the qbittorrent settings.
mkdir -p "$(dirname "${qbt_settings}")" && cat /dev/null >"${qbt_settings}"
echo '[Preferences]' | tee -a "${qbt_settings}"
echo 'Bittorrent\MaxRatio=0' | tee -a "${qbt_settings}"
echo 'Connection\PortRangeMin=18032' | tee -a "${qbt_settings}"
echo "Downloads\SavePath=${media_folder}/Torrents/" | tee -a "${qbt_settings}"
echo "Downloads\TempPath=${media_folder}/Torrents/Incomplete/" | tee -a "${qbt_settings}"
echo 'Downloads\TempPathEnabled=true' | tee -a "${qbt_settings}"
echo 'General\Locale=fr_FR' | tee -a "${qbt_settings}"
echo 'Queueing\QueueingEnabled=false' | tee -a "${qbt_settings}"
echo 'WebUI\Port=9080' | tee -a "${qbt_settings}"

# Install the resource.language.fr_fr addon.
if [ ! -d "${addon_folder}/resource.language.fr_fr" ]; then
    cd "${addon_folder}" || exit
    version=$(curl -s 'https://mirrors.kodi.tv/addons/matrix/resource.language.fr_fr/?C=M&O=D' | grep -Po 'fr_fr-\K([\d.]+)(?=.zip)' | head -1)
    curl -LO "http://mirrors.kodi.tv/addons/matrix/resource.language.fr_fr/resource.language.fr_fr-${version}.zip"
    unzip "resource.language.fr_fr-${version}.zip"
    rm "resource.language.fr_fr-${version}.zip"
    cd "${HOME}" || exit
fi

# Stop the kodi service.
systemctl stop kodi

# Edit the skin.estuary settings.
xmlstarlet ed --inplace -u '//*[@id="homemenunofavbutton"]' -v 'true' "${est_settings}"
xmlstarlet ed --inplace -u '//*[@id="homemenunogamesbutton"]' -v 'true' "${est_settings}"
xmlstarlet ed --inplace -u '//*[@id="homemenunomusicvideobutton"]' -v 'true' "${est_settings}"
# xmlstarlet ed --inplace -u '//*[@id="homemenunopicturesbutton"]' -v 'true' ${est_settings}
xmlstarlet ed --inplace -u '//*[@id="homemenunoprogramsbutton"]' -v 'true' "${est_settings}"
xmlstarlet ed --inplace -u '//*[@id="homemenunoradiobutton"]' -v 'true' "${est_settings}"
xmlstarlet ed --inplace -u '//*[@id="homemenunotvbutton"]' -v 'true' "${est_settings}"
xmlstarlet ed --inplace -u '//*[@id="homemenunovideosbutton"]' -v 'true' "${est_settings}"
xmlstarlet ed --inplace -u '//*[@id="homemenunoweatherbutton"]' -v 'true' "${est_settings}"

# Edit the gui settings.
xmlstarlet ed --inplace -u '//*[@id="addons.unknownsources"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="addons.unknownsources"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtshdpassthrough"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtshdpassthrough"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtspassthrough"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtspassthrough"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.eac3passthrough"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.eac3passthrough"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.passthrough"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.passthrough"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.truehdpassthrough"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="audiooutput.truehdpassthrough"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="locale.country"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="locale.country"]' -v 'Belgique' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="locale.language"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="locale.language"]' -v 'resource.language.fr_fr' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="slideshow.highqualitydownscaling"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="slideshow.highqualitydownscaling"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="videolibrary.backgroundupdate"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="videolibrary.backgroundupdate"]' -v 'true' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="videoplayer.adjustrefreshrate"]/@default' -v 'false' "${gui_settings}"
xmlstarlet ed --inplace -u '//*[@id="videoplayer.adjustrefreshrate"]' -v '2' "${gui_settings}"

# Start the kodi service.
systemctl start kodi

# Finally reboot the device.
reboot
