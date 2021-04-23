#!bin/bash
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - attempt to capture frames"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-a, --action=ACTION       specify an action to use"
      echo "-o, --output-dir=DIR      specify a directory to store output in"
      exit 0
      ;;
    -a)
      shift
      if test $# -gt 0; then
        echo $1
      else
        echo "no process specified"
        exit 1
      fi
      shift
      ;;
    --action*)
      echo $1 | sed -e 's/^[^=]*=//g'
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
      IFS=$'\n' sorted=($(sort <<< "${pidList[@]}")); unset IFS
      #printf "[%s]\n" "${sorted[@]}"
      # Displaying array in columns
      for value in "${sorted[@]}"
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
