Function Get-InstalledProgram{
    Param(
        [String]$ComputerName
    )
    Begin{
        $RegistryView = @([Microsoft.Win32.RegistryView]::Registry32,[Microsoft.Win32.RegistryView]::Registry64)
        $RegistryHive = [Microsoft.Win32.RegistryHive]::LocalMachine
        $SoftwareHKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    }
    Process{
        Foreach($View in $RegistryView){
            try{
                $Key = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $ComputerName, $View)
            }catch{
                $MsgBody  ="Unable to access registry on {0}. Error code: {1:x}" -f $ComputerName, $_.Exception.HResult                
                $MsgTitle = "Network error"
                $MsgType = [System.Windows.MessageBoxButton]::OK
                $MsgIcon = [System.Windows.MessageBoxImage]::Error
                $Null = [System.Windows.MessageBox]::Show($MsgBody,$MsgTitle,$MsgType,$MsgIcon)
                return
            }
            $SubKey  = $Key.OpenSubKey($SoftwareHKey)
            $KeyList = $SubKey.GetSubKeyNames()
            Foreach($Item in $KeyList){
                [PSCustomObject][Ordered]@{
                    DisplayName = $SubKey.OpenSubKey($Item).GetValue('DisplayName')
                    RegHive     = $SubKey.OpenSubKey($Item).View
                    Publisher   = $SubKey.OpenSubKey($Item).GetValue('Publisher')
                    InstallDate = $SubKey.OpenSubKey($Item).GetValue('InstallDate')
                    Version     = $SubKey.OpenSubKey($Item).GetValue('DisplayVersion')
                    UninstallString = $SubKey.OpenSubKey($Item).GetValue('UninstallString')
                }   
            }        
        }    
    }
}

[XML]$Xaml ='
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:local="clr-namespace:ViewPrograms"        
    Title="View Programs and Features" Height="600" Width="1000" WindowStyle="ToolWindow">
    <Grid>
        <Grid.ColumnDefinitions>            
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Label   Name="lblComputerName" Content="Computer Name : " HorizontalAlignment="Left" Margin="34,17,0,0" VerticalAlignment="Top" Width="110" Height="34" />
        <TextBox Name="txtComputerName" HorizontalAlignment="Left" Height="34" Margin="167,17,0,0" VerticalAlignment="Top" Width="320" Grid.IsSharedSizeScope="True"/>
        <Button  Name="btnGo" Content="Go!" HorizontalAlignment="Left" Margin="884,17,0,0" VerticalAlignment="Top" Width="75" Height="34"/>
        <DataGrid Name="dgrOutput" HorizontalAlignment="Left" Height="441" Margin="34,89,0,0" VerticalAlignment="Top" Width="925" AlternatingRowBackground="{DynamicResource {x:Static SystemColors.ActiveCaptionBrushKey}}" BorderThickness="0" IsReadOnly="True">
            <DataGrid.Columns>
                <DataGridTextColumn Header="DisplayName" Binding="{Binding DisplayName}" Width="200" />
                <DataGridTextColumn Header="RegHive"     Binding="{Binding RegHive}" Width="70" />
                <DataGridTextColumn Header="Publisher"   Binding="{Binding Publisher}" Width="130" />
                <DataGridTextColumn Header="InstallDate" Binding="{Binding InstallDate}" Width="70" />
                <DataGridTextColumn Header="Version"     Binding="{Binding Version}" Width="110" />
                <DataGridTextColumn Header="UninstallString" Binding="{Binding UninstallString}" Width="400" />
            </DataGrid.Columns>
        </DataGrid>
    </Grid>
</Window>'

Add-Type -AssemblyName PresentationFramework,PresentationCore
$reader = (New-Object System.Xml.XmlNodeReader $Xaml)
try {
    $Window = [Windows.Markup.XamlReader]::Load($reader)
}catch{
    write-Warning $_.Exception
    throw
}

$ItemNames = $Xaml.SelectNodes("//*[@Name]")
Foreach ($i in $ItemNames){
    Set-Variable -Name "ref_$($i.Name)" -Value $Window.FindName($i.Name)
}

$ref_txtComputerName.Text = $env:ComputerName

$ref_btnGo.Add_Click({
    If ([String]::IsNullOrWhiteSpace($ref_txtComputerName.Text)){
        $MsgBody  = "Please Enter The Computer Name!"
        $MsgTitle = "Missing Computer Name"
        $MsgType = [System.Windows.MessageBoxButton]::OK
        $MsgIcon = [System.Windows.MessageBoxImage]::Warning
        $Null    = [System.Windows.MessageBox]::Show($MsgBody,$MsgTitle,$MsgType,$MsgIcon)
        return
    }
    $ref_dgrOutput.Items.Clear()    
    (Get-InstalledProgram -ComputerName $($ref_txtComputerName.Text)).where{$_.DisplayName} | 
        Foreach-Object{$ref_dgrOutput.AddChild($_)}
})

$null = $Window.ShowDialog()
