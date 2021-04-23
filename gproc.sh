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
    -o)
      for entry in /proc/*
      do
	echo "$entry" | sed -e 's/\/proc\///g'
      done	
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