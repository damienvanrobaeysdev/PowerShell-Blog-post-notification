param
	(
		[String]$Title,	
		[String]$Link,
		[String]$Name,
		[String]$Logo		
	)
	
# Load assemblies
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadFrom('Assembly\MahApps.Metro.dll')      
[System.Reflection.Assembly]::LoadFrom('Assembly\System.Windows.Interactivity.dll') 


# Load XAML
function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}
$XamlMainWindow=LoadXml("WPF_notif.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Label_Close = $Form.findname("Label_Close")

$Blog_Logo = $Form.findname("Blog_Logo")
$Website_Name = $Form.findname("Website_Name")
$Post_Title = $Form.findname("Post_Title")
$Post_Link = $Form.findname("Post_Link")

$Website_Name.Content = "New post on $Name"
$Post_Title.Text = "$Title"
$Blog_Logo.ImageSource = $Logo

$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 1000

Function ClearAndClose()
{
$Timer.Stop(); 
$Form.Close(); 
$Timer.Dispose();
$Script:CountDown=5
}

Function Timer_Tick()
{

$Label_Close.Content = "The window will close in $Script:CountDown seconds"
	 --$Script:CountDown
	 if ($Script:CountDown -lt 0)
	 {
		ClearAndClose
	 }
}

$Script:CountDown = 6
$Timer.Add_Tick({ Timer_Tick})
$Timer.Start()

$Post_Link.Add_Click({
	$Browser=new-object -com internetexplorer.application
	$Browser.navigate2($Link)
	$Browser.visible=$true			
})

$Form.ShowDialog() | Out-Null
