#!/bin/sh

set -e

sig () {
  test -s "$PID" && kill -$1 `cat "$PID"`
}

oldsig () {
  test -s "$OLD_PID" && kill -$1 `cat "$OLD_PID"`
}

cmd () {
  case $1 in
    start)
      sig 0 && echo >&2 "Already running" && exit 0
      echo "Starting"
      $CMD
      ;;
    stop)
      sig QUIT && echo "Stopping" && exit 0
      echo >&2 "Not running"
      ;;
    force-stop)
      sig TERM && echo "Forcing a stop" && exit 0
      echo >&2 "Not running"
      ;;
    restart|reload)
      sig USR2 && sleep 5 && oldsig QUIT && echo "Killing old master" `cat $OLD_PID` && exit 0
      echo >&2 "Couldn't reload, starting '$CMD' instead"
      $CMD
      ;;
    upgrade)
      sig USR2 && echo Upgraded && exit 0
      echo >&2 "Couldn't upgrade, starting '$CMD' instead"
      $CMD
      ;;
    rotate)
      sig USR1 && echo rotated logs OK && exit 0
      echo >&2 "Couldn't rotate logs" && exit 1
      ;;
    *)
      echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
      exit 1
      ;;
  esac
}

setup () {
  echo -n "$RAILS_ROOT: "
  cd $RAILS_ROOT || exit 1
  export PID=$RAILS_ROOT/tmp/pids/unicorn.pid
  export OLD_PID="$PID.oldbin"
  CMD="unicorn_rails -c config/unicorn.rb -E $RAILS_ENV -D"
}

start_stop () {
  if [ $2 ]; then
    . $2
    setup
    cmd $1
  else
    for CONFIG in /etc/unicorn/*.conf; do
      . $CONFIG
      setup
      cmd $1
    done
   fi
}

ARGS="$1 $2"
start_stop $ARGS
