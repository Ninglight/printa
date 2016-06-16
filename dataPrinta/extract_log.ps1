
#####
# define initial variables

$PrintJobCounter = 1

#####
# declare helper functions

# function to print out usage data to the console
Function PrintCommandLineUsage {
    Write-Host "

Here are the script's parameters:
  (hostname) PreviousMonth -- Retrieve print job data from (hostname) based on
                              the entire previous month.
    or
  (hostname) (startdate) (enddate) -- Retrieve print job data from (hostname)
                                      based on the specified start and end
                                      dates. The date must be specified in a
                                      format that matches the current system
                                      locale (e.g. MM/dd/yyyy for United States).

Examples:
  powershell.exe -command `".\Script.ps1 localhost PreviousDay`"
  powershell.exe -command `".\Script.ps1 printserver.domain.local 10/01/2011 10/15/2011`"

"
}

#####
# parse command-line parameters

switch ($args.count) {
	{($_ -eq 2) -or ($_ -eq 3)} {
	    # the first parameter is the print server hostname from which event logs will be retrieved
        $PrintServerName = $args[0]
        Write-Host "Print server hostname to query:" $PrintServerName
	}
	2 {
        # if there are exactly two parameters, check that the second one is "PreviousDay" (using the default case-insensitive comparison)
        if ($args[1].CompareTo("PreviousDay") -eq 0) {
            # the start time is at the start (00:00:00) of the previous day
            $StartDate = (Get-Date -Hour 0 -Minute 0 -Second 0).AddDays(-1)
            # the end time is at the end (23:59:59) of the previous day
            $EndDate = (Get-Date -Hour 0 -Minute 0 -Second 0) - (New-Timespan -Second 1)
        }
        else {
            # there was a unrecognized command-line parameter, so print usage data and exit with errorlevel 1
            Write-Host "`nERROR: Two command-line parameters were detected but the second comand-line parameter was not `"PreviousDay`"."
            PrintCommandLineUsage
            Exit 1
        }
    }
    3 {
        # if there are exactly three parameters, check that the second and third ones are dates
        # set error-handling to silently continue as errors are checked explicitly
        $ErrorActionPreference = "SilentlyContinue"
        # the start time is at the start of the indicated date (12:00:00 AM)
        $StartDate = Get-Date -Date $args[1]
        # check if the command-line parameter was recognized as a valid date
        if (!$?) {
            # there was a unrecognized command-line parameter, so print usage data and exit with errorlevel 1
            Write-Host "`nERROR: Three command-line parameters were detected but the second comand-line parameter was not a valid date."
            PrintCommandLineUsage
            Exit 1
        }
        # the end time is at the end of the indicated date (11:59:59 PM) -- add a day and then subtract one second
        $EndDate = (Get-Date -Date $args[2]) + (New-Timespan -Day 1) - (New-Timespan -Second 1)
        # check if the command-line parameter was recognized as a valid date
        if (!$?) {
            # there was a unrecognized command-line parameter, so print usage data and exit with errorlevel 1
            Write-Host "`nERROR: Three command-line parameters were detected but the third comand-line parameter was not a valid date."
            PrintCommandLineUsage
            Exit 1
        }
        # set error-handling back to default
        $ErrorActionPreference = "Continue"
    }
    default {
        # there are no command-line parameters present or too many, so print usage data and exit with errorlevel 1
        Write-Host "`nERROR: No or too many command-line parameters were detected."
        PrintCommandLineUsage
        Exit 1
    }
}

#####
# define .CSV output filenames

$OutputFilenameByPrintJob = "C:\Stats_imprimantes\imp-1_" + $StartDate.ToString("d-M-yyyy") + ".csv"    # enter the desired output filename

#####
# get the ID 307 and ID 805 event log entries

# display status message
Write-Host "Collecting event logs found in the specified time range from $StartDate to $EndDate."

# the main print job entries are event ID 307 (use "-ErrorAction SilentlyContinue" to handle the case where no event log messages are found)
$PrintEntries = Get-WinEvent -ErrorAction SilentlyContinue -ComputerName $PrintServerName -FilterHashTable @{ProviderName="Microsoft-Windows-PrintService"; StartTime=$StartDate; EndTime=$EndDate; ID=307}
# the by-job number of copies are in event ID 805 (use "-ErrorAction SilentlyContinue" to handle the case where no event log messages are found)
$PrintEntriesNumberofCopies = Get-WinEvent -ErrorAction SilentlyContinue -ComputerName $PrintServerName -FilterHashTable @{ProviderName="Microsoft-Windows-PrintService"; StartTime=$StartDate; EndTime=$EndDate; ID=805}

# check for found data; if no event log ID 307 records were found, exit the script without creating an output file (this is not an error condition)
if (!$PrintEntries) {
    Write-Host "There were no print job event ID 307 entries found in the specified time range from $StartDate to $EndDate. Exiting script."
    Exit
}

# otherwise, display the number of found records and continue
#   Measure-Object is needed to handle the case where exactly one event log entry is returned
Write-Host "  Number of print job event ID 307 entries found:" ($PrintEntries | Measure-Object).Count
Write-Host "  Number of print job event ID 805 entries found:" ($PrintEntriesNumberofCopies | Measure-Object).Count

# display status message
Write-Host "Parsing event log entries and writing data to the by-print job .CSV output file `"$OutputFilenameByPrintJob`"..."

# write initial header to by-job output file
Write-Output "Date, Job, User Name, Printer Name,Total Pages, Color" | Out-File -FilePath $OutputFilenameByPrintJob -Encoding ASCII

#####
# loop to parse ID 307 event log entries

ForEach ($PrintEntry in $PrintEntries) {

    # get date and time of printjob from TimeCreated
    $StartDate_Time = $PrintEntry.TimeCreated
    # retreive the remaining fields from the event log contents
    $entry = [xml]$PrintEntry.ToXml()
    $PrintJobId = $entry.Event.UserData.DocumentPrinted.Param1
    $UserName = $entry.Event.UserData.DocumentPrinted.Param3
    $PrinterName = $entry.Event.UserData.DocumentPrinted.Param5
    $PrintPagesOneCopy = $entry.Event.UserData.DocumentPrinted.Param8

    # get the print job number of copies by correlating with event ID 805 records
    #  the ID 805 record always is logged immediately before (that is, earlier in time) its related 307 record
    #  the print job ID number restarts after a certain interval, so we need to check both for a matching job ID and a very close logging time (within 5 seconds) to its related event ID 307 record
    $PrintEntryNumberofCopies = $PrintEntriesNumberofCopies | Where-Object {$_.TimeCreated -le $StartDate_Time -and $_.TimeCreated -ge ($StartDate_Time - (New-Timespan -second 5)) -and $_.Message -eq "Rendu du travail $PrintJobId."}

	# check for found data and extract the number of copies if a matching event log ID 805 record was found
    if ($PrintEntryNumberofCopies) {
        # retrieve the remaining fields from the event log contents
        $entry = [xml]$PrintEntryNumberofCopies.ToXml()
        $NumberOfCopies = $entry.Event.UserData.RenderJobDiag.Copies
		$DocumentColor = $entry.Event.userData.RenderJobDiag.Color
        # some flawed printer drivers always report 0 copies for every print job; output a warning so this can be investigated further and set copies to be 1 in this case as a guess of what the actual number of copies was
        if ($NumberOfCopies -eq 0) {
            $NumberOfCopies = 1
            $Message = "WARNING: Printer $PrinterName recorded that print job ID $PrintJobId was printed with 0 copies. This is probably a bug in the print driver. Upgrading or otherwise changing the print driver may help. Guessing that 1 copy of the job was printed and continuing on..."
            Write-Host $Message
        }
    }
    # if no matching event log ID 805 record was found, exit with errorlevel 1 -- a matching record should always be present
    else {
        $Message = "ERROR: $StartDate_Time There were no print job event ID 805 entries found in the specified time range from $StartDate to $EndDate that matched print job id $PrintJobId. A matching record should always be present. Exiting script."
        Write-Host $Message
        #Exit 1
    }

    # calculate the total number of pages for the whole print job
    $TotalPages = [int]$PrintPagesOneCopy * [int]$NumberOfCopies

    # write output to output file
    #   put the print document name in double-quotes in case it contains a comma
    #   additional document name comma-handling: some .CSV clients don't recognize the double-quotes, so replace commas with underscores for this field
    $Output = $StartDate_Time.ToString() + "," + $PrintJobId + "," + $UserName + "," + $PrinterName + "," + $TotalPages + "," + $DocumentColor
    Write-Output $Output | Out-File -FilePath $OutputFilenameByPrintJob -Encoding ASCII -Append

    # display status message
    Write-Host "  Print job $PrintJobCounter (job ID $PrintJobId) processed."
    $PrintJobCounter++
}

#####
# quit

Write-Host "Finished."
