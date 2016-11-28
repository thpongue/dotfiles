# only clear the archive directory if we find at least 1 dot file
archiveDirectoryCleared=false

# archived dot files location - we can .gitignore this
directoryToStoreArchiveFiles=./archive

# find any file in the format <basename>.symlink and add symlink in the home directory using the format .<basename>
# eg vimrc.symlink gets symlinked as ~/.vimrc
for filename in ./*.symlink 
do
	filenameWithoutPath=$(basename $filename)
	filenameWithoutExtension="${filenameWithoutPath%.*}"
	existingFileToReplace=~/.$filenameWithoutExtension

	echo "working on" $filename

	# For some reason if no file is found it comes back with a filename of *.symlink - my hack is to just add a test for it
	if [ ! $filenameWithoutPath = "*.symlink" ]; then 
		if [ -f $existingFileToReplace ]; then
			echo "will need to archive and replace existing file" $existingFileToReplace

			# clear archive dir - but only on the first dotfile found
			if [ -d $directoryToStoreArchiveFiles ] && ! $archiveDirectoryCleared; then
				echo "deleting archive folder"
				rm -rf $directoryToStoreArchiveFiles
				archiveDirectoryCleared=true
			fi

			# create archive dir if not created yet
			if [ ! -d $directoryToStoreArchiveFiles ]; then
				echo "creating archive folder"
				mkdir $directoryToStoreArchiveFiles
			fi

			# re-add this once we know it works
			echo "copying" $existingFileToReplace "into" $directoryToStoreArchiveFiles
			mv $existingFileToReplace $directoryToStoreArchiveFiles

		else
			echo "not found"
		fi

		# create symlink
		ABS_PATH=`cd "$1"; pwd` # double quotes for paths that contain spaces etc..
		echo -e "creating symlink for" $ABS_PATH/$filenameWithoutPath "\n"
		ln -s -f $ABS_PATH/$filenameWithoutPath ~/.$filenameWithoutExtension
	fi
done

echo "done!"
