#!/usr/bin/env python

import subprocess
import sys
import os


def CheckStyle():
   svnStatCmd = "svn stat -q"
   styleCmd = ""
   if os.name == "posix":
      styleCmd = "astyle --dry-run --formatted "

   p = subprocess.Popen( svnStatCmd, stdout=subprocess.PIPE, shell=True )
   (output, err) = p.communicate()
   #split, then take every other element, starting at index 1
   files = output.split()[1::2]

   fileOutput = ''
   errOutput = ''

   for file in files:
      fileCmd = styleCmd + file
      print "Executing %s" % ( fileCmd )
      p = subprocess.Popen( fileCmd, stdout=subprocess.PIPE, shell=True )
      (output, err) = p.communicate()
      fileOutput = fileOutput + output
  
   if fileOutput:
      print "The following is in error:"
      print fileOutput
      return 1
   else:
      print "There are no style problems."
      return 0

if __name__ == "__main__":
   retVal = CheckStyle()
   sys.exit( retVal )
