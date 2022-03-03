#!/bin/bash

PACKAGE="qemu-utils"
COMMAND=""
INPUT_FILE=""
OUTPUT_FILE=""
INPUT_TYPE=""
OUTPUT_TYPE=""

query_package()
{
   echo "Checking installed packages..."

   local pkg=$(dpkg-query -l $PACKAGE | grep -o $PACKAGE)

   if [ ! $pkg ] ; then
       install_package
   fi

   echo "qemu-utils is installed....skipping"
}

install_package()
{
   echo "Installing package $PACKAGE..."

   sudo apt-get install $PACKAGE
}

convert()
{
  sudo qemu-img $COMMAND -f $INPUT_TYPE $INPUT_FILE -O $OUTPUT_TYPE $OUTPUT_FILE 
}

parse_args()
{
   while getopts "c:f:O:i:t:h:" option ;
   do
      #echo "test"
      case "${option}" in
         c)
            COMMAND=${OPTARG}
         ;;
         f)
            INPUT_FILE=${OPTARG}
         ;;
         o)
            OUTPUT_FILE=${OPTARG}
         ;;
         i)
            INPUT_TYPE=${OPTARG}
         ;;
         t)
            OUTPUT_TYPE=${OPTARG}
         ;;
         h)
            help
         ;;
      esac
   done
}

help()
{
   echo "Usage: img-convert -c [command] -if -of -it -ot"
   echo " -c               command (convert)"
   echo " -f               input file"
   echo " -o               output file"
   echo " -i               input file type (qcow2, raw, vdi, vmdk)"
   echo " -t               output file type (qcow2,raw, vdi, vmdk)"
   echo " -h               print help"
}

main()
{
   parse_args $@
   query_package
   convert
}

main $@
