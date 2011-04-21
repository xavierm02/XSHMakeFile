#!/bin/bash

### Default values ###
DassignmentOperator=": "
Dclosing="}"
DforceIndentFirstLine=0
Dindentation=""
DINDENTATION="0"
Dkey=1
DnewLine="\n"
Dopening="{"
Dtabulation="\t"

DCLOSING=$Dclosing
DOPENING=$Dopening

# usage
usage() {
cat << EOF
Usage: $0 [options] path1 [path2] [...]

Options:
    -a, --assignment-operator       Text to add between the name of a node and its content. Default: "$DassignmentOperator"
    -c, --closing                   Text to add after the content of a directory. Default: "$Dclosing"
    -C, --CLOSING                   Text to add after the content of the global directory. Default: value of -c or --closing
    -f, --force-indent-first-line   Boolean controling whether the first line should be indented or not. Default: $DforceIndentFirstLine
    -h, --help                      Output this text.
    -i, --indentation               Text to add at the beginning of every line representing the current indentation. Default: "$Dindentation"
    -I, --INDENTATION               Number of times the value of -t or --tabulation should be inserted after the value of -i or --indentation. Default: $DINDENTATION
    -k, --key                       Boolean controling the output of the filename. Default: $Dkey
    -l, --language                  Shorthand to output in some languages. If other parameters are given, they override the ones for the given language.
    -n, --new-line                  Text to add to get to the next line. Default: "$DnewLine"
    -o, --opening                   Text to add before the content of a directory. Default: "$Dopening"
    -O, --OPENING                   Text to add before the content of the global directory. Default: value of -o or --opening
    -t, --tabulation                Text to use to indent. Defaut: "$Dtabulation"

Errors:
    1: Help has been asked by -h or --help.
    2: No path has been given.
    3: One of the path given doesn't represent anything.
    4: Value given to -l or --language isn't a proper value.

EOF
}

### Check for arguments and flags ###
# For each argument or flag, store his value in corresponding variable
while [ "$1" != "" ]; do
    case $1 in
        "-a" | "--assignment-operator" )
            shift
            assignmentOperator=$1
            ;;
        "-c" | "--closing" )
            shift
            closing=$1
            ;;
        "-C" | "--CLOSING" )
            shift
            CLOSING=$1
            ;;
        "-f" | "--force-indent-first-line" )
            shift
            forceIndentFirstLine=$1
            ;;
        "-h" | "--help" )
            usage
            exit 1
            ;;
        "-i" | "--indentation" )
            shift
            indentation=$1
            ;;
        "-I" | "--INDENTATION" )
            shift
            INDENTATION=$1
            ;;
        "-k" | "--key" )
            shift
            key=$1
            ;;
        "-l" | "--language" )
            shift
            language=$1
            ;;
        "-n" | "--new-line" )
            shift
            newLine=$1
            ;;
        "-o" | "--opening" )
            shift
            opening=$1
            ;;
        "-O" | "--OPENING" )
            shift
            OPENING=$1
            ;;
        "-t" | "--tabulation" )
            shift
            tabulation=$1
            ;;
        * )
            break
    esac
    shift
done

# Check if at least one value file has been given
src=""
isFirstSrc=1
while [ "$1" != "" ]; do
    if [ -z "$1" ] || [ ! -e "$1" ] ; then
        usage
        exit 3
    else
         if [ $isFirstSrc != 0 ] ; then
            isFirstSrc=0
        else
            src+=" "
        fi
        src+="$1"
    fi
    shift
done
if [ "$src" == "" ]; then
    usage
    exit 2
fi

# For each possible argument or flag, set default value if it isn't set
if [ -z "$language" ] ; then

    if [ -z "$assignmentOperator" ] ; then
        assignmentOperator=$DassignmentOperator
    fi
    if [ -z "$closing" ] ; then
        closing=$Dclosing
    fi
    if [ -z "$CLOSING" ] ; then
        CLOSING=$DCLOSING
    fi
    if [ -z "$key" ] ; then
        key=$Dkey
    fi
    if [ -z "$opening" ] ; then
        opening=$Dopening
    fi
    if [ -z "$OPENING" ] ; then
        OPENING=$DOPENING
    fi

elif [ "$language" == "js" ] ; then
    
    if [ -z "$assignmentOperator" ] ; then
        assignmentOperator=": "
    fi
    if [ -z "$key" ] ; then
        key=1
    fi
    if [ "$key" == "1" ] ; then
        if [ -z "$opening" ] ; then
            opening="{"
        fi
        if [ -z "$OPENING" ] ; then
            OPENING="{"
        fi
        if [ -z "$closing" ] ; then
            closing="}"
        fi
        if [ -z "$CLOSING" ] ; then
            CLOSING="}"
        fi
    else
        if [ -z "$opening" ] ; then
            opening="["
        fi
        if [ -z "$OPENING" ] ; then
            OPENING="["
        fi
        if [ -z "$closing" ] ; then
            closing="]"
        fi
        if [ -z "$CLOSING" ] ; then
            CLOSING="]"
        fi
    fi
    
elif [ "$language" == "php" ] ; then
    
    if [ -z "$assignmentOperator" ] ; then
        assignmentOperator=" => "
    fi
    if [ -z "$closing" ] ; then
        closing=")"
    fi
    if [ -z "$CLOSING" ] ; then
        CLOSING=")"
    fi
    if [ -z "$key" ] ; then
        key=1
    fi
    if [ -z "$opening" ] ; then
        opening="Array("
    fi
    if [ -z "$OPENING" ] ; then
        OPENING="Array("
    fi
    
else
    
    usage
    exit 4
    
fi


if [ -z "$forceIndentFirstLine" ] ; then
    forceIndentFirstLine=$DforceIndentFirstLine
fi
if [ -z "$indentation" ] ; then
    indentation=$Dindentation
fi
if [ -z "$INDENTATION" ] ; then
    INDENTATION=$DINDENTATION
fi
if [ -z "$newLine" ] ; then
    newLine=$DnewLine
fi
if [ -z "$tabulation" ] ; then
    tabulation=$Dtabulation
fi

i=0
while [ $i -lt $INDENTATION ] 
do 
   indentation="$indentation$tabulation"
   i=`expr $i + 1` 
done

### Functions definition ###

#outputChildNodes path nodeName indentation
outputChildNodes( ) {
    local path=$1
    local nodeName=$2
    local indentation=$3
    
    outputNodes $path/$nodeName "$indentation" "0" `ls $path/$nodeName`
}

#outputNodes path indentation nodeName1 [nodeName2] [...]
outputNodes( ) {
    local path=$1
    local indentation=$2
    local isFirstLevel=$3
    local isfirstnode=1
    local childNodeName
    
    shift 3
    
    while [ "$1" != "" ]; do
        childNodeName=$1
        if [ $isfirstnode != 0 ] ; then
            isfirstnode=0
        else
            output+=",$newLine"
        fi
        if [ $isFirstLevel == 1 ] ; then
            if [ $forceIndentFirstLine == 1 ] ; then
                output+=$indentation
            fi
        else
            output+=$indentation
            if [ $key != 0 ] ; then
                output+="\"${childNodeName%.*}\"$assignmentOperator"
            fi
        fi
        outputNode $path $childNodeName $isFirstLevel $indentation
        shift
    done
}

# outputDir path nodeName indentation
outputDirectory( ) {
    local path=$1
    local nodeName=$2
    local isFirstLevel=$3
    local indentation=$4
    
    if [ "$isFirstLevel" == "1" ]; then
        output+="$OPENING"
    else
        output+="$opening"
    fi
    
    output+="$newLine"
    outputChildNodes $path $nodeName $tabulation$indentation
    output+="$newLine$indentation"
    if [ "$isFirstLevel" == "1" ]; then
        output+="$CLOSING"
    else
        output+="$closing"
    fi
}

# outputFile path filename indentation
outputFile( ) {
    local path=$1
    local filename=$2
    local indentation=$3
    local IFS=" "
    local isfirstline=1
    
    while read line ; do
        if [ $isfirstline != 0 ] ; then
            isfirstline=0
        else
            output+="$newLine$indentation"
        fi
        output+="$line"
    done < $path/$filename
}

# outputNode path nodeName indentation isFirstLevel 
outputNode( ) {
    local path=$1
    local nodeName=$2
    local isFirstLevel=$3
    local indentation=$4
    
    if [ -d $path/$nodeName ] ; then
        outputDirectory $path $nodeName $isFirstLevel $indentation
    else
        outputFile $path $nodeName $indentation
    fi
}

### Main script ###
output=""

outputNodes '.' "$indentation" "1" $src

echo -en "$output"
