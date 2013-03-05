function Stop-TimedSection {
<#
.SYNOPSIS
Ends a timed section

.DESCRIPTION
A timed section is a portion of script that is timed. Used 
with Start-TimedSection, the beginning and end of the section 
are loged to both the console and the log along with the 
amount of time elapsed.

.PARAMETER SectionId
The guid that was generated by Start-TimedSection and 
identifies which section is ending.

.EXAMPLE
$session=Start-TimedSection "My First Section"
Stop-TimedSection $session

This creates a block as follows:

+ Boxstarter starting My First Section

Some stuff happens here.

+ Boxstarter finished My First Section 00:00:00.2074282

.EXAMPLE
Timed Sections can be nested or staggered. You can have 
multiple sections running at once.

$session=Start-TimedSection "My First Section"
$innerSession=Start-TimedSection "My Inner Section"
Stop-TimedSection $innerSession
Stop-TimedSection $session

This creates a block as follows:

+ Boxstarter starting My First Section

Some stuff happens here.

++ Boxstarter starting My Inner Section

Some inner stuff happens here.

++ Boxstarter finished My Inner Section 00:00:00.1074282

Some more stuff happens here.

+ Boxstarter finished My First Section 00:00:00.2074282

Note that the number of '+' chars indicate nesting level.

.LINK
http://boxstarter.codeplex.com
Start-TimedSection
#>
    param([string]$SectionId)
    $timerEntry=$script:boxstarterTimers.$SectionId
    if(!$timerEntry){return}
    $padCars="".PadLeft($boxstarterTimers.Count,"+")
    $script:boxstarterTimers.Remove($SectionId)
    $stopwatch = $timerEntry.stopwatch
    Write-BoxstarterMessage "$padCars Boxstarter finished $($timerEntry.Title) $($stopwatch.Elapsed.ToString())" -NoLogo 
    $stopwatch.Stop()
}