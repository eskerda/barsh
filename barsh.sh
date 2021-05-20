#!/usr/bin/env bash

# barsh is a minimal progress bar implementation on 7 lines of readable bash

# you know you want to!
# curl https://raw.githubusercontent.com/eskerda/barsh/master/barsh.sh | bash

function barsh {
  [[ $# -lt 2 ]] && return 1
  local val=$1; local bas=$2; local txt=$3; local wid=$4;

  [[ -z $wid ]] && { [[ -z $txt ]] && wid=$bas || wid=${#txt} ; }
  [[ -z $txt ]] && txt="$(printf '%*s' "$wid" '')"
  [[ $wid -gt ${#txt} ]] && txt=$txt$(printf '%*s' $((${#txt} - wid)) '')

  local per=$(( (wid * val) / bas ))
  printf "\033[7m%s\033[27m%s" "${txt:0:$per}" "${txt:$per:$((wid-per))}"
}

# script is not sourced
if [[ ${#BASH_SOURCE[@]} -lt 2 ]]; then
  # has arguments
  if [[ $# -gt 0 ]]; then
    barsh "$@"
  else
    cat << EOF
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
0   5▏  10▏  15▏  20▏  25▏  30▏  35▏  40▏  45▏  50▏  55▏  60▏  65▏  70▏  75▏  80

$ barsh 10 40
$(barsh 10 40)

$ barsh 20 40
$(barsh 20 40)

$ barsh 30 40
$(barsh 30 40)

$ barsh 40 40
$(barsh 40 40)

$ barsh 75 100 "" 40
$(barsh 75 100 "" 40)

$ barsh 1 2 "" 40
$(barsh 1 2 "" 40)

$ barsh 1 4 "" 40
$(barsh 1 4 "" 40)

$ barsh 40 80
$(barsh 40 80)

$ barsh 60 80
$(barsh 60 80)

$ barsh 80 80
$(barsh 80 80)

$ barsh 100 100 "" 80
$(barsh 100 100 "" 80)

$ barsh 75 100 "" 80
$(barsh 75 100 "" 80)

$ barsh 50 100 "" 80
$(barsh 50 100 "" 80)

$ barsh 25 100 "" 80
$(barsh 25 100 "" 80)

$ barsh 25 100 "Lorem ipsum dolor sit amet" 80
$(barsh 25 100 "Lorem ipsum dolor sit amet" 80)

$ barsh 100 100 "Lorem ipsum dolor sit amet" 80
$(barsh 100 100 "Lorem ipsum dolor sit amet" 80)

$ barsh 25 100 "Lorem ipsum dolor sit amet"
$(barsh 25 100 "Lorem ipsum dolor sit amet")

$ barsh 100 100 "Lorem ipsum dolor sit amet"
$(barsh 100 100 "Lorem ipsum dolor sit amet")
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
0   5▏  10▏  15▏  20▏  25▏  30▏  35▏  40▏  45▏  50▏  55▏  60▏  65▏  70▏  75▏  80

EOF

    # https://easings.net/#easeInOutSine
    # - (cos ( PI * x) - 1) / 2
    easeInOutSine=()
    for i in $(seq 0 200); do
      easeInOutSine+=("$(LC_ALL=C; printf '%.f\n' $(bc -l <<< "- ( c ( (4 * a(1)) * ($i/100) ) - 1) * 100 / 2"))")
    done

    duration=0.5
    interval=$(bc -l <<< "$duration / ${#easeInOutSine[@]}")
    width=80; [[ $COLUMNS -lt $width ]] && width=$COLUMNS

    printf "\n\n\n\n\033[4A\033[s"

    while true; do
      for i in "${easeInOutSine[@]}"; do
        printf "\033[u\033[?25l\033[31m%b\033[1E\033[33m%b\033[1E\033[32m%b\033[2E\033[0m\033[?25h" \
          "$(barsh $i 100 " $i %" $width)" \
          "$(barsh $((100-i)) 100 " $((100-i)) %" $width)" \
          "$(barsh $i 100 " $i %" $width)"
        sleep $interval
      done
    done
  fi
fi
