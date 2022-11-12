# barsh: a minimal bash progress bar

barsh is a 7-lines implementation of a progress bar in bash, using bg/fg color
ANSI escape sequences instead of block characters. Use it directly as a
standalone tool on your shell, source it and use it on your scripts, or just
admire it in all its glory

```bash
function barsh {
  [[ $# -lt 2 ]] && return 1
  local val=$1; local bas=$2; local txt=$3; local wid=$4;

  [[ -z $wid ]] && { [[ -z $txt ]] && wid=$bas || wid=${#txt} ; }
  [[ -z $txt ]] && txt="$(printf '%*s' "$wid" '')"
  [[ $wid -gt ${#txt} ]] && txt=$txt$(printf '%*s' $((${#txt} - wid)) '')

  local per=$(( (wid * val) / bas ))
  printf "\033[7m%s\033[27m%s" "${txt:0:$per}" "${txt:$per:$((wid-per))}"
}
```

## Usage demo

```bash
$ curl https://raw.githubusercontent.com/eskerda/barsh/master/barsh.sh | bash
```

<img src="https://eskerda.com/wp-content/uploads/2021/05/barsh-term.gif" width="600px">
