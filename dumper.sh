#!/usr/bin/env bash
#
# Copyright (C) 2022 a Renayura <renayura@proton.me>
#

MAIN_DIR=$(pwd)

# Telegram Setup
git clone --depth=1 https://github.com/fabianonline/telegram.sh Telegram

TELEGRAM="$MAIN_DIR/Telegram/telegram"
tgm() {
	"${TELEGRAM}" -H -D \
		"$(
			for POST in "${@}"; do
				echo "${POST}"
			done
		)"
}

tgf() {
	"${TELEGRAM}" -H \
		-f "$1" \
		"$2"
}

# Clone DunprX repos
git clone --depth=1 https://github.com/DumprX/DumprX
cd DumprX

# Setup configs
bash setup.sh
git config --global user.name "Renayura"
git config --global user.email "renayura@proton.me"
echo "$GH_TOKEN" > .github_token
echo "$ORG" > .github_orgname
echo "$TELEGRAM_CHAT" > .tg_chat
echo "$TELEGRAM_TOKEN" > .tg_token

# Start dumping firmware
tgm "<b>Dump firmware started...</b>
<b>Fiwmare link</b> : <code>$LINK</code>"
bash dumper.sh $LINK | tee error.log

# Send error log to telegram
if ! [ -a "error.log" ]; then
	LOG=$(echo error.log)
	tgf "$LOG" "❌ <b>Dump Failed...</b>"
	exit 1
  else
	tgm "✅ <b>Dump Successfully..</b>"
fi
