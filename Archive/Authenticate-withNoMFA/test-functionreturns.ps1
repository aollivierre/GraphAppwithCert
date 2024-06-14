function foo1 {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
        $processes = $null
        $services = $null
    }
    
    process {

        try {
            
            $processes = Get-Process  | Select-Object -First 3
            $services = Get-Service | Select-Object -First 3
        }
        catch {
            
        }
        finally {
            
        }


        
    }
    
    end {

        # return $processes.ProcessName, $processes.ID

        Write-Host "some output to console" -ForegroundColor Green
        return $processes, $services

        
    }
}



function foo2 {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {

        try {
            
            $results = $null
            $results = foo1
            $Processesarray = $results[0]
            $Servicesarray = $results[1]

            # $DBG

            # $results | Get-Member

           
        }
        catch {
            
        }
        finally {
            
        }
        
    }
    
    end {

        # $Processnameresult = $results.ProcessName

        # write-host $Processnameresult
        # write-host $results.ID

        # $results

        $Foo1_Array = $null
        $Foo1_Array = [PSCustomObject]@{
            # ProcessNameResult  = $results.ProcessName
            ProcessNameResult  = $Processesarray.ProcessName
            ProcessIDResult    = $Processesarray.ID
            ServicesNameResult = $Servicesarray.name
        }

        return $Foo1_Array

        # $results.item
        
    }
}


# foo2

foo1