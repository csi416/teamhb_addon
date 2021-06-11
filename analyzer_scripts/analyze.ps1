param(
    [Parameter(Mandatory)]$sourcePath
)

#$sourcePath = "e:\Developing\teamhb\THBPowerShell\src\mex_hun_01.txt"
#Write-Output "$sourcePath"
$source = [System.IO.File]::ReadAllLines($sourcePath)

$teamHome = $source[0].Split(':')[1].Trim()
$teamAway = ""
$i = 1
while ($teamAway -eq "")
{
    if ($source[$i].StartsWith('['))
    {
        if (-Not $source[$i].Contains($teamHome))
        {
            $parts = $source[$i].Split(':')[1].Split('-')
            $teamAway = $parts[$parts.Length - 1].Trim()
        }
    }
    $i++
}
$scoreHome = 0
$scoreAway = 0
$summary = ""
$tacticsHome = $teamHome + ":" + [System.Environment]::NewLine
$tacticsAway = $teamAway + ":" + [System.Environment]::NewLine
$min = ""
$actualTeam = ""

for ($i = 2; $i -lt $source.Length; $i++)
{
    $line = $source[$i]
    # ha "státusz" sor van, akkor nézem volt-e gól
    if ($line.Substring(0, 1) -eq "[")
    {
        if ($line.Contains($teamHome))
        {
            $actualTeam = $teamHome
        }
        else
        {
            $actualTeam = $teamAway
        }
        $min = $line.Split(' ')[0].Substring(1)
        # ha gól van, megállapítom ki lőtte
        if ($line.Contains("GOAL"))
        {
            if ($line.Contains($teamHome))
            {
                $scoreHome++
            }
            else
            {
                $scoreAway++
            }
            $summary += $min + ". min: " + $scoreHome + " : " + $scoreAway + [System.Environment]::NewLine
        }
    }
    # ha "szöveges" sor, akkor nézem volt-e csere
    else
    {
        if ($line.Contains("Formation change") -or $line.Contains("change their formation") -or $line.Contains("New players coming"))
        {
            $summary += $min + ". min: " + $line + [System.Environment]::NewLine
        }
        elseif ($line.Contains("crosses"))
        {
            if ($actualTeam -eq $teamHome)
            {
                $tacticsHome += $min + ". min: Cr" + [System.Environment]::NewLine
            }
            else
            {
                $tacticsAway += $min + ". min: Cr" + [System.Environment]::NewLine
            }
        }
        elseif ([System.Text.RegularExpressions.Regex]::Matches($line, "runs in").Count -gt 1)
        {
            if ($actualTeam -eq $teamHome)
            {
                $tacticsHome += $min + ". min: Ri" + [System.Environment]::NewLine
            }
            else
            {
                $tacticsAway += $min + ". min: Ri" + [System.Environment]::NewLine
            }
        }
        elseif ($line.Contains("from the distance") -or $line.Contains("jumps and shoots") -or $line.Contains("jumps up and shoots"))
        {
            if ($actualTeam -eq $teamHome)
            {
                $tacticsHome += $min + ". min: Js" + [System.Environment]::NewLine
            }
            else
            {
                $tacticsAway += $min + ". min: Js" + [System.Environment]::NewLine
            }
        }
        elseif ($line.Contains("passes it right back"))
        {
            if ($actualTeam -eq $teamHome)
            {
                $tacticsHome += $min + ". min: Pop" + [System.Environment]::NewLine
            }
            else
            {
                $tacticsAway += $min + ". min: Pop" + [System.Environment]::NewLine
            }
        }
        elseif ($line.Contains("right-left feint") -or $line.Contains("fast one-two motion") -or $line.Contains("one fluent motion") -or $line.Contains("fancies his chances"))
        {
            if ($actualTeam -eq $teamHome)
            {
                $tacticsHome += $min + ". min: Dr" + [System.Environment]::NewLine
            }
            else
            {
                $tacticsAway += $min + ". min: Dr" + [System.Environment]::NewLine
            }
        }
    }
}

$summary += [System.Environment]::NewLine + $tacticsHome + [System.Environment]::NewLine + $tacticsAway

Write-Output $summary
