#!/bin/sh

sudo valac --pkg gtk+-3.0 Imafe.vala -o /bin/imafe

sudo mkdir /usr/share/pixmaps/imafe/

sudo cp resource/*.png /usr/share/pixmaps/imafe/

sudo cp imafe.desktop /usr/share/applications/

imafe
