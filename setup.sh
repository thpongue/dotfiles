for filename in ~/dotfiles/*.symlink 
do
	#find any file with the extension .symlink and add symlink in the home directory using the format .<basename>
	#eg vimrc.symlink gets symlinked as ~/.vimrc
	#there is nothing clever here to check for existing files so be careful with this
	#symlink syntax: ln -s <source> <target>
	filenameWithoutPath=$(basename $filename)
	filenameWithoutExtension="${filenameWithoutPath%.*}"
	unlink $filenameWithoutPath
	ln -s $filename ~/.$filenameWithoutExtension
done
