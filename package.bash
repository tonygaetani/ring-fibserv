#!/usr/bin/env bash
set -euo pipefail

IFS=
# http://stackoverflow.com/a/246128/6554
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	# if $SOURCE was a relative symlink, we need to resolve it relative to the
	# path where the symlink file was located
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

IFS=$'\n\t'

if [[ -z "${1-}" ]]; then
	echo "usage: bash package.bash <path to jar>" >&2
	exit 100
fi

JAR_FILE="${1}"
JAR_NAME="${JAR_FILE%.*}"
JAR_FILE_PATH="${DIR}/target/${JAR_FILE}"
DEB_DIR="${DIR}/fibserv-deb"

ln -sf "${JAR_FILE_PATH}" "${DEB_DIR}/srv/fibserv/dist/fibserv.jar"

dpkg --build "${DEB_DIR}"
mv "${DEB_DIR}.deb" "${JAR_NAME}.deb"

