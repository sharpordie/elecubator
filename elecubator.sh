#!/usr/bin/env bash

# Constant variables.
readonly ADDON_FOLDER="${HOME}/.kodi/addons"
readonly AGENT_STRING="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"
readonly ESTUARY_CONF="${HOME}/.kodi/userdata/addon_data/skin.estuary/settings.xml"
readonly GUI_SETTINGS="${HOME}/.kodi/userdata/guisettings.xml"
readonly MEDIA_FOLDER="/var/media/$(ls /var/media | sort -n | head -1)"
readonly QBITT_CONFIG="${HOME}/.opt/etc/qBittorrent_entware/config/qBittorrent.conf"
readonly SOURCES_FILE="${HOME}/.kodi/userdata/sources.xml"

# Create the folder tree on the external drive.
if [ "${MEDIA_FOLDER}" != "/var/media/" ]; then
    mkdir -p "${MEDIA_FOLDER}/Albums"
    # mkdir -p "${MEDIA_FOLDER}/Animes"
    # mkdir -p "${MEDIA_FOLDER}/Cartoons"
    mkdir -p "${MEDIA_FOLDER}/Movies"
    mkdir -p "${MEDIA_FOLDER}/Pictures"
    mkdir -p "${MEDIA_FOLDER}/Series"
    mkdir -p "${MEDIA_FOLDER}/Torrents"
    mkdir -p "${MEDIA_FOLDER}/Torrents/Incomplete"
    mkdir -p "${MEDIA_FOLDER}/Tutorials"
fi

# Install the entware package manager and reboot.
if ! [ -x "$(command -v opkg)" ]; then yes | installentware; fi

# Install the qbittorrent package.
opkg update && opkg upgrade
opkg install qbittorrent

# Edit the qBittorrent.conf file.
mkdir -p "$(dirname "${QBITT_CONFIG}")" && cat /dev/null >"${QBITT_CONFIG}"
echo '[Preferences]' | tee -a "${QBITT_CONFIG}"
echo 'Bittorrent\MaxRatio=0' | tee -a "${QBITT_CONFIG}"
echo 'Connection\PortRangeMin=18032' | tee -a "${QBITT_CONFIG}"
echo "Downloads\SavePath=${MEDIA_FOLDER}/Torrents/" | tee -a "${QBITT_CONFIG}"
echo "Downloads\TempPath=${MEDIA_FOLDER}/Torrents/Incomplete/" | tee -a "${QBITT_CONFIG}"
echo 'Downloads\TempPathEnabled=true' | tee -a "${QBITT_CONFIG}"
echo 'General\Locale=fr_FR' | tee -a "${QBITT_CONFIG}"
echo 'Queueing\QueueingEnabled=false' | tee -a "${QBITT_CONFIG}"
echo 'WebUI\Port=9080' | tee -a "${QBITT_CONFIG}"

# Install the resource.language.fr_fr addon.
if [ ! -d "${ADDON_FOLDER}/resource.language.fr_fr" ]; then
    cd "${ADDON_FOLDER}"
    version=$(curl -s 'https://mirrors.kodi.tv/addons/matrix/resource.language.fr_fr/?C=M&O=D' | grep -Po 'fr_fr-\K([\d.]+)(?=.zip)' | head -1)
    curl -A "${AGENT_STRING}" -LO "http://mirrors.kodi.tv/addons/matrix/resource.language.fr_fr/resource.language.fr_fr-${version}.zip"
    unzip "resource.language.fr_fr-${version}.zip"
    rm "resource.language.fr_fr-${version}.zip"
    cd "${HOME}"
fi

# Stop the kodi service.
systemctl stop kodi

# Edit the settings.xml file from estuary skin.
# xmlstarlet ed --inplace -u '//*[@id="homemenunofavbutton"]' -v 'true' ${ESTUARY_CONF}
xmlstarlet ed --inplace -u '//*[@id="homemenunogamesbutton"]' -v 'true' ${ESTUARY_CONF}
xmlstarlet ed --inplace -u '//*[@id="homemenunomusicvideobutton"]' -v 'true' ${ESTUARY_CONF}
# xmlstarlet ed --inplace -u '//*[@id="homemenunopicturesbutton"]' -v 'true' ${ESTUARY_CONF}
# xmlstarlet ed --inplace -u '//*[@id="homemenunoprogramsbutton"]' -v 'true' ${ESTUARY_CONF}
xmlstarlet ed --inplace -u '//*[@id="homemenunoradiobutton"]' -v 'true' ${ESTUARY_CONF}
xmlstarlet ed --inplace -u '//*[@id="homemenunotvbutton"]' -v 'true' ${ESTUARY_CONF}
# xmlstarlet ed --inplace -u '//*[@id="homemenunovideosbutton"]' -v 'true' ${ESTUARY_CONF}
xmlstarlet ed --inplace -u '//*[@id="homemenunoweatherbutton"]' -v 'true' ${ESTUARY_CONF}

# Edit the guisettings.xml file.
xmlstarlet ed --inplace -u '//*[@id="addons.unknownsources"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="addons.unknownsources"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtshdpassthrough"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtshdpassthrough"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtspassthrough"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.dtspassthrough"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.eac3passthrough"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.eac3passthrough"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.passthrough"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.passthrough"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.truehdpassthrough"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="audiooutput.truehdpassthrough"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.country"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.country"]' -v 'Belgique' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.language"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.language"]' -v 'resource.language.fr_fr' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="slideshow.highqualitydownscaling"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="slideshow.highqualitydownscaling"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="videolibrary.backgroundupdate"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="videolibrary.backgroundupdate"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="videoplayer.adjustrefreshrate"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="videoplayer.adjustrefreshrate"]' -v '2' ${GUI_SETTINGS}

# Start the kodi service.
systemctl start kodi

# Finally reboot the device.
reboot
