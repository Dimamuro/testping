function test-ping()
{
    param($TargetHost, 
            $Detail = $false,
            $BufferSize = 32)

    function Play-OkSound()
    {
        [console]::beep(500,500)
        [console]::beep(600,500)
        [console]::beep(800,400)
    }

    function Play-DownSound()
    {
        [console]::beep(800,400)
        [console]::beep(600,500)
        [console]::beep(400,700)
    }


    #$Check = $false
    $LossCounts=0
    while($true){
        if((Test-Connection $TargetHost -Count 1 -BufferSize $BufferSize -Quiet) -eq $true -and $Check -eq $false){
            Play-OkSound
            $name = [system.net.dns]::GetHostByAddress($TargetHost).hostname
            Write-Host -BackgroundColor Green -ForegroundColor Black "$(get-date) - $name ($TargetHost) is ok!"
            if($Detail){Test-Connection $TargetHost -Count 1 -BufferSize $BufferSize}
            #Test-Connection $TargetHost -Count 1
            
            $Check = $true
            continue
        }
        if((Test-Connection $TargetHost -Count 1 -BufferSize $BufferSize -Quiet) -eq $false -and $Check -ne $false){
            Play-DownSound
            $LossCounts++
            Write-Host -BackgroundColor red "$(get-date) - $TargetHost is down! Loss counts - $LossCounts"
            $Check = $false
            continue
        }
        if((Test-Connection $TargetHost -Count 1 -BufferSize $BufferSize -Quiet) -eq $true -and $Check -eq $null)
        {
            $Check = $false
        }
    }
}
