#!/usr/bin/env bash

# Constant variables.
readonly ADDON_FOLDER='/storage/.kodi/addons'
readonly AGENT_STRING='Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0'
readonly GUI_SETTINGS='/storage/.kodi/userdata/guisettings.xml'
readonly QBITT_CONFIG='/storage/.kodi/userdata/addon_data/service.qbittorrent/.config/qBittorrent/qBittorrent.conf'
readonly SOURCES_FILE='/storage/userdata/sources.xml'
readonly THORADIA_URL='https://github.com/thoradia/thoradia'

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

# Install the thoradia repository.
if [ ! -d "${ADDON_FOLDER}/service.thoradia" ]; then
    cd "${ADDON_FOLDER}"
    curl -A "${AGENT_STRING}" -OL "${THORADIA_URL}/releases/download/9.80.6.25/service.thoradia-9.80.6.25.zip"
    unzip service.thoradia-9.80.6.25.zip
    rm service.thoradia-9.80.6.25.zip
    cd "${HOME}"
fi

# Install the qbittorrent service.
if [ ! -d "${ADDON_FOLDER}/service.qbittorrent" ]; then
    cd "${ADDON_FOLDER}"
    curl -A "${AGENT_STRING}" -OL "${THORADIA_URL}/raw/9.80.9/9.80.9/ARMv8/arm/service.qbittorrent/service.qbittorrent-9.80.9.35.zip"
    unzip service.qbittorrent-9.80.9.35.zip
    rm service.qbittorrent-9.80.9.35.zip
    cd "${HOME}"
fi

# Edit the qBittorrent.conf file.
mkdir -p "$(dirname "${QBITT_CONFIG}")" && cat /dev/null >"${QBITT_CONFIG}"
echo 'Bittorrent\MaxRatio=0' | tee -a "${QBITT_CONFIG}"
echo 'Downloads\SavePath=/var/media/External/Torrents/' | tee -a "${QBITT_CONFIG}"
echo 'Downloads\TempPath=/var/media/External/Torrents/Incomplete/' | tee -a "${QBITT_CONFIG}"
echo 'Downloads\TempPathEnabled=true' | tee -a "${QBITT_CONFIG}"
echo 'General\Locale=fr_FR' | tee -a "${QBITT_CONFIG}"
echo 'WebUI\Username=admin' | tee -a "${QBITT_CONFIG}"
