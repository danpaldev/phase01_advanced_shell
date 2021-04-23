#!bin/bash
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Gproc - An easy cli tool for PID inspection"
      echo " "
      echo " "
      echo "Options:             Arguments:                  "
      echo " "
      echo "-h, --help           Show brief help"
      echo "-i, --info=PID       Get info about a specific PID"
      echo "--get-all-pids       Get ALL the processes running in your system nicely sorted"
      exit 0
      ;;
    -i)
      shift
      if test $# -gt 0; then
        pid=$1
	who_folder=$(sudo lsof -w -p ${pid} | grep cwd | awk '{ print $9 }')
	who_user=$(sudo lsof -w -p ${pid} | grep cwd | awk '{ print $3 }')
	triggered_by_cmd=$(< /proc/$pid/cmdline)
	echo "$pid Process"
	echo "Working directory on $who_folder"
	echo "Ran by user ${who_user}"
	echo "Triggered by command ${triggered_by_cmd}"

      else
        echo "no process specified"
        exit 1
      fi
      shift
      ;;
    --info*)
      if test $# -gt 0; then
	pid=$(echo $1 | sed -e 's/^[^=]*=//g')
	who_folder=$(sudo lsof -w -p ${pid} | grep cwd | awk '{ print $9 }')
	who_user=$(sudo lsof -w -p ${pid} | grep cwd | awk '{ print $3 }')
	triggered_by_cmd=$(< /proc/$pid/cmdline)
	echo "$pid Process"
	echo "Working directory on $who_folder"
	echo "Ran by user ${who_user}"
	echo "Triggered by command ${triggered_by_cmd}"

      else
        echo "no process specified"
        exit 1
      fi
      shift
      ;;
    --get-all-pids)
      pidList=()
      for entry in /proc/*
      do
	res=$(echo "$entry" | sed -e 's/\/proc\///g')
	if [ "$res" -eq "$res" ] 2> /dev/null 
	then
	    pidList+=($res)	
	    #echo $res
	fi
      done
      #Sorting Arrays in Bash - https://stackoverflow.com/a/11789688/13954598
      sortedPidList=($(sort <<< "${pidList[@]}"))
      for value in "${sortedPidList[@]}"
      do
          printf "%-8s\n" "${value}"
      done | column
      shift
      ;;
    --output-dir*)
      export OUTPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done
