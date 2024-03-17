# filename: main.ps1
# author : Yoshida
function main {

    param ( 
        [bool]$isSuspend
    )

    $reffVal=[xml](Get-Content -Encoding UTF8 "$PSScriptRoot\refference.xml")

# main :Start from here

    if ($true -eq $isSuspend){
        return '200'
    }

    class main { 
        [string[]]$reffName=@( `
            "subtask_1.ps1", `
            "subtask_2.ps1"
        )

        [hashtable]$retCode

        [string]$retVal

        main (){
            $this.retCode=@{}
            $this.retVal
        }


        # サブタスクが同じ配下にある前提
        [void]GetReturnCode([string]$reffName){

            $this.retVal=""

            $reffPath = Join-Path $PSScriptRoot $reffName
            . $reffPath

            $funcName= $reffName[0..8] -join ''

            $this.retVal= & $funcName

            $this.retCode[$reffName]=$this.retVal

        }
    }

    $Main = [main]::new()

# main : Return from here

    try { 

        for ($i=0; $i -lt $Main.reffName.Count; $i++){
            
            $reffName = $Main.reffName[$i]
            $Main.GetReturnCode($reffName)

            if ('100' -ne $Main.retCode[$reffName]){
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : "+"`t"+"$reffName でエラーが起きました"
                break 
            }
        }

    }catch{
        return '99999'
    }

    if("" -ne $Message){
        Add-Content -Path $reffVal.logPath.InnerText -Value $Message
        return $Main.retCode[$reffName]
    }

    return $Main.retVal

}






