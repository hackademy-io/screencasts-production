#!/bin/bash

SOURCE_FILE=/etc/apt/sources.list.d/pgdg.list

echo "Installing postgresql database"

echo "   - Adding the official apt repository to the sources"
if [ ! -f "$SOURCE_FILE" ]; then
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > $SOURCE_FILE
fi

echo "   - Import the repository key"
wget -q -O - "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | apt-key add -

echo "   - Update the repository"
apt-get update -qq

echo "   - Install the required packages"
apt-get install -y postgresql-9.3 pgadmin3

echo "   - Create an vagrant role"
su postgres -c "createuser vagrant"
