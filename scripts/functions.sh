# open or create text file for today
# uses or creates folder for current year and month

function today {
  rootPath=~/OneDrive/Writing
  thisYear=$rootPath/$(date +"%Y")
  thisMonth=$thisYear/$(date +"%m")
  fileName=$thisMonth/$(date +"%d")-$(date +"%B").txt

  mkdir -p $thisMonth

  if [ ! -e $fileName ]; then 
    touch "$fileName"
  fi

  # Note opening both rootPath and fileName ensures 
  # the whole notes folder structure is opened.
  echo "Opening $fileName for editing..."
  nvim "+Goyo" "+set linebreak" $fileName
}

function findMavenLastUpdated {
  find /c/tools/maven-repository -name \*.lastUpdated 
}

function cleanMavenLastUpdated {
  find /c/tools/maven-repository -name \*.lastUpdated -exec rm -fv {} +
}


function video-dl {

    if [ -e "${1:?}" ]; 
    then
        echo "Please supply a url"
    else 
        pushd ~/OneDrive/Videos &> /dev/null
        youtube-dl --recode-video mp4 $@
        popd &> /dev/null
    fi
  
}
