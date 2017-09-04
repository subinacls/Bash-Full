getexif() {
 echo -e "[-] Running exiftool against files in: ${PWD##*/}\n\t[!] Please wait till finished~\n"
 # automated exiftool metadata extraction
 # make and store files from downloaded sources supported by exiftool
 checkexifdir() {
  # checks if there is an existing directory to hold results
  # if not, make them as needed for this function
  if [ ! -d ./evidence ]; then
   mkdir ./evidence
  fi
  if [ ! -d $bdir/exif-metadata ]; then
   mkdir $bdir/exif-metadata
  fi
  if [ ! -d $evidir/tagdump ]; then
   mkdir $evidir/tagdump
  fi
  if [ ! -d $evidir/common ]; then
   mkdir $evidir/common
  fi
  if [ ! -d $evidir/allfiles ]; then
   mkdir $evidir/allfiles
  fi
  bdir="./evidence"
  evidir="$bdir/exif-metadata"
  tagdir="$evidir/tagdump"
  comdir="$evidir/common"
  alldir="$evidir/allfiles"
 }
 # runs exiftool and dumps a files with .exif extension of all found meta-rich sources
 exiffiledump() {
  exiftool  -all -r ./* -txt -w exif > $comdir/author_output_${PWD##*/} 2>/dev/null;
 }
 # moves all exif files to the evidence directory
 moveexif() {
  find ./ -name "*.exif" -print0 |\
  xargs -0 -I {} mv {} $alldir 2>/dev/null;
 }
 # gets all tags from exif files for additional processing
 gettags() {
  cat $alldir/*.exif | \
  cut -d ":" -f1 | \
  sort -u | \
  tr -s " \t" | \
  sed -r "s/(.*) /\1/g";
 }
 # takes all tags form gettags and does a grep across all files in evidence
 # this is to make individual files with all relevant into tag files in tag dir
 maketags() {
  IFS=$'\n';
  for x in $(gettags); do
   a=`echo $x | \
   tr -s " " "_" | \
   tr -s "\/" "_"`;
   grep $x $alldir/*.exif > $tagdir/tag_$a;
  done;
  IFS=$' ';
 }
 # produces a csv file with all revelant information about the metadata found
 # examine file after running to get author, creator, and software as needed
 exifcsv() {
  exiftool -r -all -csv ./* > $comdir/csv_output_${PWD##*/};
 }
 # dumps creator information into a file
 exifcreator() {
  grep -i creator $alldir/*.exif | \
  grep -iv history |\
  cut -d":" -f3 | \
  tr -s "," "\n" | \
  sed -r "s/ (.*)/\1/g" | \
  sort -u > $comdir/creator_output_${PWD##*/};
 }
 # runs grep and strips out only the History related information from the metadata
 exifhistory() {
  grep -i history $alldir/*.exif | \
  cut -d":" -f3 | \
  tr -s "," "\n" | \
  sed -r "s/ (.*)/\1/g" | \
  sort -u > $comdir/history_output_${PWD##*/};
 }
 # runs grep and strips out only the Author related information from the metadata
 exifauthor() {
  grep -i author $alldir/*.exif | \
  cut -d":" -f3 | \
  tr -s "," "\n" | \
  sed -r "s/ (.*)/\1/g" | \
  sort -u > $comdir/author_output_${PWD##*/};
 }
 # runs grep and strips out only the Software related information from the metadata
 exifsoftware() {
  grep -i software $alldir/*.exif | \
  cut -d":" -f3 | \
  tr -s "," "\n" | \
  sed -r "s/ (.*)/\1/g" | \
  sort -u > $comdir/software_output_${PWD##*/};
 }
 # runs the exif functions above, wrapped together for logical execution
 # run this in the parent directory where you downloaded a site
 (checkexifdir);
 (exiffiledump);
 (moveexif);
 (maketags);
 (exifcsv);
 (exifauthor);
 (exifcreator);
 (exifhistory);
 (exifsoftware);
}
