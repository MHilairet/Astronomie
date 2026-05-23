# Periodic Error Analysis script in Python

## This script compute the Periodic Error of a mount based on a plate solve of fits file

* Version 0.3 : here https://github.com/LeCocherAstro/Periodic_Error_Analysis
  * SIRIL python script with an interface
  * Plate solve using ASTAP and GAIA
 
* Version 0.2 : ![](PEC_Analysis_v0p1.py)
  *   Plate solve using ASTAP and PS3

  * Config.txt file : ![](config.txt)
     * Add the path of ASTAP tool and/or PS3
     * Example : 
       astap,D:\ProgramOnD\astap\astap.exe
       ps3,D:\ProgramOnD\Platesolve3_80\PlateSolve3.80.exe

   * dir_fits_file.txt file : ![](dir_fits_file.txt)
     * Add the path of the fits files to read
     * tool,astap     : to using astap as plate solve tool
     * platesolve_on  : ask a plate solve
     * platesolve_off : no plate solve (because it has been yet done) and just
                      a plot of the signal is ask

     * Example : 
       dir_fits_file,D:\Documents\PEC_Analyse\File_Under_Test
       tool,astap
       platesolve_on, 
