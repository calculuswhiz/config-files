using namespace System.IO

# Watch a target folder or file
function Start-FSWatch()
{
    param(
        [Parameter(Mandatory=$True)]$Target,
        $Action={""},
        [switch]$Silent=$False, 
        [switch]$StayAlive=$False,
        [int]$Timeout=0
    )

    #Set up Timer
    $lock = [ref]$False

    $timer = [System.Timers.Timer]::new()
    if ($Timeout -gt 0)
    {
        $timer.Interval = $Timeout
        $timer.AutoReset = $False
    }

    $OnTick =
    {
        $myArgs = $event.MessageData

        $myArgs.lock.Value = $False
        $myArgs.timer.Stop()
    }

    #Set up Watch
    $watcher = [FileSystemWatcher]::new()
    
    $isTargetDirectory = (Get-Item $Target) -is [System.IO.DirectoryInfo]

    if (-not $isTargetDirectory)
    {
        $watcher.Path = (Get-Item $Target).DirectoryName
        $watcher.Filter = (Get-Item $Target).Name
    }    
    else
    {
        $watcher.Path = $Target
    }

    $watcher.NotifyFilter = $NotifyFilters::LastWrite -bor
        $NotifyFilters::FileName -bor
        $NotifyFilters::DirectoryName

    $watcher.EnableRaisingEvents = $True;

    $OnChanged = 
    {
        $myArgs = $event.MessageData
        $params = $myArgs.Params
        $event = $event.SourceEventArgs

        if ($myArgs.lock.Value)
        {
            return
        }

        if ($params.Silent -ne $True)
        {
            Write-Host $event.ChangeType ":" $event.FullPath
        }

        [Scriptblock]::Create($params.Action).Invoke()

        if ($params.StayAlive -ne $True)
        {
            Write-Host "Terminating watch"
            Stop-FSWatch
        }

        if ($params.Timeout -gt 0)
        {
            $myArgs.lock.Value = $True
            $myArgs.timer.Start()
        }
    }

    $OnRenamed = 
    {
        $myArgs = $event.MessageData
        $params = $myArgs.Params
        $event = $event.SourceEventArgs

        if ($myArgs.lock.Value)
        {
            return
        }

        if ($params.Silent -ne $True)
        {
            Write-Host $event.ChangeType: $event.OldFullPath "->" $event.FullPath
        }

        $([Scriptblock]::Create($params.Action)).Invoke()

        if ($params.StayAlive -ne $True)
        {
            Write-Host "Terminating watch"
            Stop-FSWatch
        }

        if ($params.Timeout -gt 0)
        {
            $myArgs.lock.Value = $True
            $myArgs.timer.Start()
        }
    }

    #Register events
    $params = @{}
    foreach ($h in $MyInvocation.MyCommand.Parameters.GetEnumerator())
    {
        try
        {
            $key = $h.Key
            $val = Get-Variable -Name $key -ErrorAction Stop | Select-Object -ExpandProperty Value -ErrorAction Stop
            if ([string]::IsNullOrEmpty($val) -and (-not $PSBoundParameters.ContainsKey($key)))
            {
                throw "Error in key: $key"
            }
            $params[$key] = $val
        }
        catch
        {}
    }
    
    $passThru = 
    @{
        Params = $params;
        
        lock = $lock;
        timer = $timer;
    }

    Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier File.Changed -Action $OnChanged -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier File.Created -Action $OnChanged -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName Deleted -SourceIdentifier File.Deleted -Action $OnChanged -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName Renamed -SourceIdentifier File.Renamed -Action $OnRenamed -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $timer -EventName Elapsed -SourceIdentifier Tick -Action $OnTick -MessageData $passThru | Out-Null

    Write-Host "Now Watching: `"$($watcher.Path)`" for changes, filtered on $($watcher.Filter)"
    Write-Host "To cancel, run Stop-FSWatch"
}

# Cancel the watch
function Stop-FSWatch()
{
    Unregister-Event -SourceIdentifier File.Changed
    Unregister-Event -SourceIdentifier File.Created
    Unregister-Event -SourceIdentifier File.Deleted
    Unregister-Event -SourceIdentifier File.Renamed
    Unregister-Event -SourceIdentifier Tick

    Write-Host "Canceled FSWatch"
}

Export-ModuleMember -Function Start-FSWatch, Stop-FSWatch
