#!/bin/bash
#2013-10-23 by Edison Qian
#calculte the code lines in the formated files
#excluding blank lines and comment lines
#examples used "*.lisp"

sh_file_path=`pwd`"/count_lines_in_files.sh";
echo path: $sh_file_path;
echo "this file uses only" `cat $sh_file_path | sed -e '/^#/d' -e '/^$/d' | wc -l` lines of codes;
a=0
for i in ./*.lisp
	do
		line_in_file=`cat $i | sed -e 's/.$/\r/g' | sed -e '/^#/d' -e '/^$/d' | wc -l`;
		echo "file name:" $i ",total lines:" $line_in_file;
		a=$[ $a + $line_in_file];
	done

echo "all files total lines=" $a
