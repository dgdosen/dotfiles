autoload -U zgitinit
zgitinit

revstring() {
	git describe --always $1 2>/dev/null ||
	git rev-parse --short $1 2>/dev/null
}

coloratom() {
	local off=$1 atom=$2
	if [[ $atom[1] == [[:upper:]] ]]; then
		off=$(( $off + 60 ))
	fi
	echo $(( $off + $colorcode[${(L)atom}] ))
}
colorword() {
	local fg=$1 bg=$2 att=$3
	local -a s

	if [ -n "$fg" ]; then
		s+=$(coloratom 30 $fg)
	fi
	if [ -n "$bg" ]; then
		s+=$(coloratom 40 $bg)
	fi
	if [ -n "$att" ]; then
		s+=$attcode[$att]
	fi

	echo "%{"$'\e['${(j:;:)s}m"%}"
}

function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1 2>/dev/null`
    if $lastcommit ; then
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      echo $minutes_since_last_commit
    else
      echo "-1"
    fi
}

function days_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1 2>/dev/null`
    if $lastcommit ; then
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      days_since_last_commit=$((minutes_since_last_commit/60/24))
      echo $days_since_last_commit
      # echo $minutes_since_last_commit
    else
      echo "-1"
    fi
}

function prompt_grb_scm_time_since_commit() {
	local -A pc
	pc=(${(kv)wunjo_prompt_colors})

	if zgit_inworktree; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
        local DAYS_SINCE_LAST_COMMIT=`days_since_last_commit`

        if [ "$MINUTES_SINCE_LAST_COMMIT" -eq -1 ]; then
          COLOR="$pc[scm_time_uncommitted]"
          TIME= "$MINUTES_SINCE_LAST_COMMIT"
          UNIT="m"
          local SINCE_LAST_COMMIT="${COLOR}uncommitted$pc[reset]"
        else
          if [ "$DAYS_SINCE_LAST_COMMIT" -gt 1 ]; then
            UNIT="d"
            TIME="$DAYS_SINCE_LAST_COMMIT"
            COLOR="$pc[scm_time_long]"
          else
            UNIT="m"
            TIME="$MINUTES_SINCE_LAST_COMMIT"
            if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 60 ]; then
              COLOR="$pc[scm_time_long]"
            elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
              COLOR="$pc[scm_time_medium]"
            else
              COLOR="$pc[scm_time_short]"
            fi
          fi
          local SINCE_LAST_COMMIT="${COLOR}${TIME}${UNIT}$pc[reset]"
        fi
        echo $SINCE_LAST_COMMIT
    fi
}

export SINCE_LAST_COMMIT="$(prompt_grb_scm_time_since_commit)"
