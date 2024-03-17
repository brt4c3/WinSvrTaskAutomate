# filename: subtask_2.ps1
# author : Yoshida
function subtask_2 {

    param ( 
        [bool]$isSuspend
    )

    $reffVal=[xml](Get-Content -Encoding UTF8 "$PSScriptRoot\refference.xml")

# main :Start from here

    if ($true -eq $isSuspend){
        return '200'
    }
    class main {
        
        main (){
            $this.Inventory
            $this.flg
        }

<# ---------------------------------------
        KICK the bat files
-----------------------------------------#>

<# ---------------------------------------
        Collect the log of bat files
-----------------------------------------#>

 
    }
}