# VMware vCenter environment variables

# The vCenter server hostname, IP, or FQDN. For VMware Cloud on AWS, this should look like: 'vcenter.sddc-[ip address].vmwarevmc.com'.
vcenter_server = "" 

# The username for authenticating to vCenter (don't forget two backslashes \\ if you use a domain).
username = "%domainname%\\%serviceaccount%"

# The plaintext password for authenticating to vCenter.
password = ""

# If true, does not validate the vCenter server's TLS certificate.
insecure_connection = false

# The vSphere datacenter name. Required if there is more than one datacenter in vCenter.
datacenter = ""

# The VM virtual hardware version. (https://kb.vmware.com/s/article/1003746)
vm_version = 19

# The file name of the VMware Tools for Windows ISO image installation media. ISOs are expected to be uploaded to the datastore in a directory/folder named 'ISO'. (https://packages.vmware.com/tools/esx)
iso_filename_vmware_tools = "VMware-tools-windows-11.3.0-18090558.iso"

# Azure environment variables
azure_client_secret = ""
azure_client_id = ""
azure_tenant_id = ""
azure_subscription_id = ""
azure_resource_group_name = ""
azure_temp_resource_group_name = ""
azure_shared_image_gallery_name = ""
azure_virtual_network_name = ""
azure_virtual_network_subnet_name = ""

# Image template variables
organization_name = ""
support_hours = "Monday to Friday - 9:00 AM - 5:00 PM."
support_phone_number = ""
support_url = "https://website.com"
domainname = ""
dnssuffixlist = ""


# Printer related variables
printer1_ipaddr = ""
printerdriver1_dirname = ""
printerdriver1_inf = ""
printerdriver1_name = ""
printer1_name = ""
printer2_ipaddr = ""
printerdriver2_dirname = ""
printerdriver2_inf = ""
printerdriver2_name = ""
printer2_name = ""

# Other related variables
psfunction_path = "C:\\PackerTemp\\PSFunctions"
tempdriver_path = "C:\\PackerTemp\\Drivers"
rootca = "RootCA.cer"
sadomjoin = "%domainname%\\%serviceaccount%"

# Software related variables
softwarerepo = "\\\%domainfqdn%\\org\\ImgSoftware"
tempsoft_path = "C:\\PackerTemp\\Software"
certs_path = "C:\\PackerTemp\\Certificates"
vmwareosot_dirname = "VMware OS Optimization Tool"
vmwareosot_inst = "VMwareHorizonOSOptimizationTool-x86_64-2107.exe"
vc_redist2005sp1_x86_dirname = "vcredist_2005sp1_x86"
vc_redist2005sp1_x64_dirname = "vcredist_2005sp1_x64"
vc_redist2008sp1_x86_dirname = "vcredist_2008sp1_x86"
vc_redist2008sp1_x64_dirname = "vcredist_2008sp1_x64"
vc_redist2010sp1_x86_dirname = "vcredist_2010sp1_x86"
vc_redist2010sp1_x64_dirname = "vcredist_2010sp1_x64"
vc_redist2012u4_x86_dirname = "vcredist_2012u4_x86"
vc_redist2012u4_x64_dirname = "vcredist_2012u4_x64"
vc_redist2013u5_x86_dirname = "vcredist_2013u5_x86"
vc_redist2013u5_x64_dirname = "vcredist_2013u5_x64"
dotnet_framework_48_dirname = "Microsoft DotNet Framework"
office_365_dirname = "Microsoft Office 365 Apps for Enterprise"
office_365_confinst = "Custom-Configuration-Office365-x64.xml"
teams_dirname = "Microsoft Teams"
bginfo_dirname = "Microsoft BGinfo"
bginfo_conffile = "BGinfo-VMware-VDI.bgi"
powershell_dirname = "Microsoft PowerShell"
acrobat_reader_dc_dirname = "Adobe Acrobat Reader DC"
acrobat_reader_dc_patch_filename = "AcroRdrDCUpd2100720099_MUI.msp"
vlc_player_dirname = "VideoLAN VLC Player"
sevenzip_dirname = "7-Zip"
java_re_x86_dirname = "Oracle JavaRE x86"
java_re_x64_dirname = "Oracle JavaRE x64"
java_re_version = "1.8.0_301"
greenshot_dirname = "Greenshot"
greenshot_inst = "Greenshot-INSTALLER-1.2.10.6-RELEASE.exe"
greenshot_conffile = "Greenshot-fixed.ini"
edge_enterprise_dirname = "Microsoft Edge Enterprise"
edge_enterprise_version = "96.0.1054.62"
chrome_enterprise_dirname = "Google Chrome Enterprise"
firefox_enterprise_dirname = "Mozilla Firefox Enterprise"
horizon_agent_dirname = "VMware Horizon Agent"
horizon_direct_con_agent_dirname = "VMware Horizon Direct Connection Agent"
horizon_daas_agent_dirname = "VMware Horizon DaaS Agent"
horizon_client_dirname = "VMware Horizon Client"
dem_agent_dirname = "VMware DEM Agent"
dem_profiler_dirname = "VMware DEM Profiler"
appvol_agent_dirname = "VMware App Volumes Agent"
appvol_mgr_fqdn = "%appvolumesfqdn%"
appvol_mgr_port = "443"
thinapp_dirname = "VMware ThinApp"