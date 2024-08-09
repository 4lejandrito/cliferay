if [ ${#other_args[@]} -eq 0 ]; then
    telnet localhost 11311
else
expect <<EOF
spawn telnet localhost 11311
expect "g! "
send "${other_args[*]}\r"
expect "g! "
send "disconnect\r"
expect "Disconnect from console? (y/n; default=y)"
send "y\r"
expect eof
EOF
fi
