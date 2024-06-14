finally {


            
    # Get End Time 
    $endDTM = (Get-Date)
     
    ## Echo Time elapsed 
    $Timemin = "Elapsed Time: $(($endDTM-$startDTM).totalminutes) minutes"
    $Timesec = "Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"

    ## Provide time it took 
    Write-host "" 
    Write-host " Prcoess has been completed......" -fore Green -back black
    Write-host " Process took $Timemin       ......" -fore Blue
    Write-host " Process $Dest_PC took $Timesec        ......" -fore Blue
    
}