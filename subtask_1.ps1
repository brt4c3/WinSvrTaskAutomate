# filename: subtask_1.ps1
# author : Yoshida
function subtask_1 {

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
            $this.LoggingItems
            $this.flg
        }

        [string]DistributeFiles($reffPath){
            try{
                Copy-Item `
                    -Path $this.Inventory `
                    -Destination "\\$reffPath" -Force
            }catch{
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : Error"+"`t" `
                    +"Failed to copy file with"+"   $reffPath" 
                $this.flg='200'
            } finally{
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : Success"+"`t" `
                    +"Copied file"+"   $reffPath" 
            }
            return $Message
        }

        [string]UnzipFiles($reffPath){
            try{
                Expand-Archive `
                    -Path $reffPath `
                    -Destination 'D:\Bat' `
                    -ErrorAction Stop
            }catch{
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : Error"+"`t" `
                    +"Failed to copy file with"+"   $reffPath" 
                $this.flg='200'
            } finally{
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : Success"+"`t" `
                    +"Copied file"+"   $reffPath" 
            }
            return $Message
        }

        [string]LoggingItems($reffPath){
            try{
                $retVal=Get-ChildItem -Path $reffPath
                $retVal | ForEach-Object{
                    $this.LoggingItems+=$_.Name 
                }
            }catch{
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : Error"+"`t" `
                    +"Failed to log items with"+"   $reffPath"
                $this.flg='200'
            }finally{
                $Message = ${get-date -format "yyyy/MM/dd HH:mm:ss"} `
                    +" : Success"+"`t" `
                    +"logging Items with "+"   $reffPath" 
            }
            return $Message
        }
    }

    $Main = [main]::new()

# main : Return from here
    $Main.Inventory = $reffVal.Inventory.InnerText
    $Message = $Main.DistributeFiles($reffVal.Computer.InnerText)
    if("" -ne $Message){
        Add-Content `
            -Path $reffVal.logPath.InnerText `
            -Value $Message
    }

    $Message = $Main.UnzipFiles($reffVal.ZipFile.InnerText)
    if("" -ne $Message){
        Add-Content `
            -Path $reffVal.logPath.InnerText `
            -Value $Message
    }

    [string]$ItemPath='\\'+$reffVal.Computer.InnerText+'D:\Bat\'+$reffVal.ZipFile.InnerText
    $Message = $Main.LoggingItems($ItemPath)
    if("" -ne $Message){
        Add-Content `
            -Path $reffVal.logPath.InnerText `
            -Value $Message
    }

    $LoggingItems = $Main.LoggingItems
    for ($i = 0; $i -lt $LoggingItems.Count; $i++) {
        Add-Content `
            -Path $reffVal.logPath.InnerText `
            -Value "`t Items : "+"`t"+$LoggingItems[$i]
    }

    if($Main.flg -ne '200'){
        $retVal='100'
    } else {
        $retVal=$Main.flg
    }

    return $retVal
}