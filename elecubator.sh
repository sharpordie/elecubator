#!/usr/bin/env bash

# Constant variables.
readonly ADDON_FOLDER='/storage/.kodi/addons'
readonly AGENT_STRING='Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0'
readonly GUI_SETTINGS='/storage/.kodi/userdata/guisettings.xml'

# Edit the guisettings.xml file.
xmlstarlet ed --inplace -u '//*[@id="addons.unknownsources"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="addons.unknownsources"]' -v 'true' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.country"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.country"]' -v 'Belgique' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.language"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="locale.language"]' -v 'resource.language.fr_fr' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="videoplayer.adjustrefreshrate"]/@default' -v 'false' ${GUI_SETTINGS}
xmlstarlet ed --inplace -u '//*[@id="videoplayer.adjustrefreshrate"]' -v '2' ${GUI_SETTINGS}
