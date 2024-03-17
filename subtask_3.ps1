# filename: subtask_2.ps1
# author : Yoshida
function subtask_3 {

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

<# -----------------------------------------
        Delete the batch files and logs
-------------------------------------------#>
        [void]SelfDistruct($reffVal){
            Remove-Item `
                -Path $reffVal `
                -Force -Recurse
        }

    }

    $ScriptBlock={
        $Main = [main]::new()
        $Main.SelfDistruct("D:\Bat")
    }

    try{
        Invoke-command `
            -ComputerName $reffVal.ComputerName `
            -ScriptBlock $ScriptBlock
        $retVal='100'
    }catch{
        $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
            +" : Error"+"`t" `
            +"Failed to remove items with`t"+   $reffVal.ComputerName
        $retVal='200'
    }finally{
        $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
            +" : Success"+"`t" `
            +""+"   $reffPath" 
    }

    Add-Content `
        -Path $reffVal.logPath.InnerText `
        -Value $Message

    return $retVal 
}