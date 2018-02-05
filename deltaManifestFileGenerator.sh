#!bin/sh

## Description: This shell file used to prepare delta Manifest file used for manifest based deployed used by Jenkins
##              Script all the components committed after a specified tagged commmit. Tag name is passed as a parameter
## Usage: Called from Git CLI
## Note : Script needs to be run by passing certain parameters


#==========================================================
# Calculate the number of commits after the tag name 
#==========================================================
count=$(git log --pretty=oneline head...$1 | wc -l )

echo ""
echo "***********************************************************"
echo "Total number of Commits: " $count
echo "***********************************************************"

if [ $count = 0 ]
then
    echo "No components to be deployed"
else   		
	## if components.txt file exist already then delete it
	if [ -e "components.txt" ]
		then
			rm components.txt
	fi
				
	## command to prepare components file
	git diff --diff-filter=MARCT  HEAD~$count --name-only >> components.txt
	
	## Generate the file containing all the list of components to be which were commited
	truncate -s 0 componentsFile.txt
	sed 's/[a-zA-Z_]*\///g' components.txt >> componentsFile.txt
	
	echo ""
	echo "***********************************************************"
	echo "Total Number of components(Non Deleted): "$(cat components.txt | wc -l)
	echo "***********************************************************"
	
	echo ""
	echo "***********************************************************"
	echo "Total number Of newly added Components: " $(git diff --diff-filter=A  HEAD~$count --name-only | wc -l)
	echo "Newly Added Components Are:"
	#git diff --diff-filter=A  HEAD~$count --name-only
	echo "***********************************************************"
	
	echo ""
	echo "***********************************************************"
	echo "Total number of deleted components: " $(git diff --diff-filter=D  HEAD~$count --name-only | wc -l)
	echo "Deleted Components Are (Not included in component file):"
	#git diff --diff-filter=D  HEAD~$count --name-only
	echo "***********************************************************"

fi 

#echo "Total Number of components: "$(cat components.txt | wc -l)

#==========================================
#find max depth of folder structure
#if component path is src/classes/example.cls then depth is 1
#if component path is src/reports/IPM_Reports/example.report then depth is 2 
#Depth is calculated as : (Max Occurence of / character in a line)-1
#===========================================
filename='components.txt'

# variable to store maximum
max_occurences=0;

echo ""
echo "Starting Process...."

# Read each line of the components.txt file and find count of / characters in that line
while read p; do 

	number_of_occurrences=$(grep -o "/" <<< "$p" | wc -l)
	
	#echo $number_of_occurrences of /
	if [[ $max_occurences -lt $number_of_occurrences ]]
		then 
		max_occurences=$number_of_occurrences
	fi
done < $filename

echo ""
echo "***********************************************************"
echo "Maximum depth of folder structure is" $max_occurences
echo "***********************************************************"

maxDepthFolderStrt=$max_occurences

#=====================================================================
# prepare manifest file using regex to find the folder structure
#=====================================================================

# empty all the temporary files used. If they are not present then they are created
truncate -s 0 componentstemp.txt
truncate -s 0 test.txt
truncate -s 0 tempManifest.txt
truncate -s 0 uniqManifest.txt
truncate -s 0 project-manifest-$2.txt 

#Initail regex
#regExForFolderStrt="^[a-zA-Z_]*/"
regExForFolderStrt=""

##Applying regex for the depth of the folder
#for 1st iteration regex is "^src/[a-zA-Z_]*/" (matches "src/classes/")
#for 2nd iteration regex is "^src/[a-zA-Z_]*/[a-zA-Z_]*/" (matches "src/reports/IPM_Reports/")
# and so on
counter=$maxDepthFolderStrt

while [ $counter -gt 0 ]
do
	if [ $counter = $maxDepthFolderStrt ]
	then 
	   regExForFolderStrt="^[a-zA-Z_$]*/"
	else
	   regExForFolderStrt=$regExForFolderStrt"[a-zA-Z_$]*/"
	fi
	
	# add matched strings to componentstemp.txt file after removing trailing /
	grep -io $regExForFolderStrt components.txt | sed 's/.$//' >> componentstemp.txt
	
	counter=`expr $counter - 1`
	
done

echo ""
echo "Starting delta manifest file preparation ..."

# find all the unique folder structure and put it in test file
uniq -u componentstemp.txt >> test.txt

# find all the duplicate folder structre and put it in test file
uniq -d componentstemp.txt >> test.txt

# put the componets file content to test file
cat components.txt >> test.txt

##Add meta files of all .cls files
regExForClass="\.cls$"
regExForTrigger="\.trigger$"
regExForPage="\.page$"
regExForComponent="\.component$"
regExForResource="\.resource$"
regExForEmail="\.email$"
regExForPNG="\.png$"
regExForGIF="\.gif$"
regExForCMP="\.cmp$"
regExForEVT="\.evt$"
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ $regExForClass || "$line" =~ $regExForTrigger || "$line" =~ $regExForPage || "$line" =~ $regExForComponent || "$line" =~ $regExForResource || "$line" =~ $regExForEmail || "$line" =~ $regExForPNG || "$line" =~ $regExForGIF || "$line" =~ $regExForCMP || "$line" =~ $regExForEVT ]];
	then
	
		#echo "$line"
		echo "$line" >> tempManifest.txt
		echo "$line"'-meta.xml' >> tempManifest.txt
		#match="$line"
		#echo $match
		#insert="$line"'-meta.xml'
		#echo 'inset: '$insert
		#sed -i "s/$match/$match\n$insert/" "file.txt"
	else
	    if grep -Fxq "$line"'-meta.xml' "test.txt"
		then
			echo "matched"
		else
			echo "$line" >> tempManifest.txt
		fi
	fi
done < "test.txt"

#Preparation of actual manifest file
#add the base src directory
#echo "src" >> project-manifest-$2.txt

# find all the unique folder structure and put it in test file
uniq -u tempManifest.txt >> uniqManifest.txt

# find all the duplicate folder structre and put it in test file
uniq -d tempManifest.txt >> uniqManifest.txt

# replace / with \ in the test file and append its content to actual manifest file
#sed 's/\//\\/g' uniqManifest.txt | sort >> project-manifest-$2.txt
cat uniqManifest.txt | sort >> project-manifest-$2.txt

echo ""
echo "***********************************************************"
echo "Manifest files is as follows:"
cat project-manifest-$2.txt


# Remove temporary files
rm uniqManifest.txt
rm components.txt
rm test.txt
rm componentstemp.txt
rm tempManifest.txt

echo ""
echo "****************End Of Process*****************************"


