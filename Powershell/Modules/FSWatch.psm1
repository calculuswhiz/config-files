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
    $FileSystemWatcher = [System.IO.FileSystemWatcher]
    $NotifyFilters = [System.IO.NotifyFilters]
    $watcher = $FileSystemWatcher::new()
    
    $isTargetDirectory = (Get-Item $Target) -is [System.IO.DirectoryInfo]

    if (-not $isTargetDirectory)
    {
        $watcher.Path = (Get-Item $Target).DirectoryName
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
        $event = $event.SourceEventArgs

        if ($myArgs.lock.Value -or 
            -not ($myArgs.isTargetDirectory -or
               (Get-Item $myArgs.Target).FullName -eq $event.FullPath))
        {
            return
        }

        if ($myArgs.Silent -ne $True)
        {
            Write-Host $event.ChangeType ":" $event.FullPath
        }

        [Scriptblock]::Create($myArgs.Action).Invoke()

        if ($myArgs.StayAlive -ne $True)
        {
            Write-Host "Terminating watch"
            Stop-FSWatch
        }

        if ($myArgs.Timeout -gt 0)
        {
            $myArgs.lock.Value = $True
            $myArgs.timer.Start()
        }
    }

    $OnRenamed = 
    {
        $myArgs = $event.MessageData
        $event = $event.SourceEventArgs

        if ($myArgs.lock.Value)
        {
            return
        }

        if ($myArgs.Silent -ne $True)
        {
            Write-Host $event.ChangeType: $event.OldFullPath "->" $event.FullPath
        }

        $([scriptblock]::Create($myArgs.Action)).Invoke()

        if ($myArgs.StayAlive -ne $True)
        {
            Write-Host "Terminating watch"
            Unwatch-FileSystem
        }

        if ($myArgs.Timeout -gt 0)
        {
            $myArgs.lock.Value = $True
            $myArgs.timer.Start()
        }
    }

    #Register events
    $passThru = 
    @{
        Target = $Target; 
        Action = $Action; 
        StayAlive = $StayAlive; 
        Silent = $Silent; 
        Timeout = $Timeout; 

        lock = $lock;
        timer = $timer;
        isTargetDirectory = $isTargetDirectory;
    }

    Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier File.Changed -Action $OnChanged -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier File.Created -Action $OnChanged -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName Deleted -SourceIdentifier File.Deleted -Action $OnChanged -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $watcher -EventName Renamed -SourceIdentifier File.Renamed -Action $OnRenamed -MessageData $passThru | Out-Null
    Register-ObjectEvent -InputObject $timer -EventName Elapsed -SourceIdentifier Tick -Action $OnTick -MessageData $passThru | Out-Null

    Write-Host "Now Watching: `"$Target`" for changes"
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

    Write-Host "Canceled FS Watch"
}

Export-ModuleMember -Function Start-FSWatch, Stop-FSWatch
