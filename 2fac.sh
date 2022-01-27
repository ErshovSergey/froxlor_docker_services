#!/bin/bash

APP_KEY=akqe2xgd6n8h9p6iaeramzak4kk
USER_KEY=u8o9gyfc2nmrvtt5t7n4epk27v

# Priority of the message
#  -2 - no notification/alert
#  -1 - quiet notification
#   0 - normal priority
#   1 - bypass the user's quiet hours
#   2 - require confirmation from the user
PRIORITY=0

#   Notification sound to play with message
#                               pushover - Pushover (default)
#                               bike - Bike
#                               bugle - Bugle
#                               cashregister - Cash Register
#                               classical - Classical
#                               cosmic - Cosmic
#                               falling - Falling
#                               gamelan - Gamelan
#                               incoming - Incoming
#                               intermission - Intermission
#                               magic - Magic
#                               mechanical - Mechanical
#                               pianobar - Piano Bar
#                               siren - Siren
#                               spacealarm - Space Alarm
#                               tugboat - Tug Boat
#                               alien - Alien Alarm (long)
#                               climb - Climb (long)
#                               persistent - Persistent (long)
#                               echo - Pushover Echo (long)
#                               updown - Up Down (long)
#                               none - None (silent)
SOUND="cosmic"
URL="https://api.pushover.net/1/messages.json"

# генерим случайные user/password
uuser=`openssl rand -hex 2`
ppwd=`openssl rand -hex 4`
echo $uuser $ppwd
TITLE=$uuser
MESSAGE="$ppwd"

# добавляем пользователя
htpasswd -cb /var/customers/webs/InProduction/glpi.erchov.ru/.htpasswd $uuser $ppwd

# отправляем данные
RESPONSE=`curl -s --data sound=$SOUND --data  token=$APP_KEY --data user=$USER_KEY --data-urlencode title="$TITLE" --data priority=$PRIORITY --data-urlencode message="$MESSAGE" $URL`

# если не удалось отправить push - отправляем почтой
status=`echo $RESPONSE |  grep -Po '"status":\s*\K\d+'`
if [[ $status -ne 1 ]] ; then
  echo "Error send push notifications. Send creditinals to email"
  echo "$TITLE $MESSAGE" | mail -s "$TITLE" "ershovu@gmail.com" -r "STATUS_CHECKER"
else
  exit 0
fi
