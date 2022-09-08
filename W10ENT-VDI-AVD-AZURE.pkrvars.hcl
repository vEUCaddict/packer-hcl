# Azure Windows 10 VDI Multi-Session variables
azure_shared_image_gallery_image_name = ""
azure_managed_image_name = ""
azure_os_type = "Windows"
azure_image_publisher = "MicrosoftWindowsDesktop"
azure_image_offer = "Windows-10"
azure_image_sku = "win10-21h2-avd"
azure_location = "westus"
azure_vm_size = "Standard_D2_v2"

# Communicators are the mechanism Packer uses to upload files, execute scripts, etc. with the machine being created. Options are: none, ssh and winrm.
packer_communicator = "winrm"

# The amount of time to wait for WinRM to become available in string format. This defaults to 30m since setting up a Windows machine generally takes a long time. Example = "1h5m2s".
winrm_timeout = "2h30m0s"

# The username to use to authenticate over WinRM-HTTPS.
winrm_username = "packer"

# The plaintext password to use to authenticate over WinRM-HTTPS.
winrm_password = ""

# The username of the new local administator account.
localvdiadmin = "LocalVDIadmin"

# Windows 10 - Start Layout
w10_startlayout_dirname = "Microsoft Windows 10 - StartLayout"
w10_startlayout_xmlfile = "LayoutModification.xml"

# Windows 10 - Target Release Version Information (on which version of the OS needs to stay).
target_release_version = "21H2"

# Windows 10 - VMware OS Optimization Tool - NOGPU Template.
vmwareosot_tempxml = "Windows-10-20H2-NOGPU-Template-v1.xml"

# Windows 10 - Dutch Language and Feature Packs
dutchlp_dirname = "Microsoft Windows 10 - 20H2 NL-LP"

# Windows 10 - Microsoft .NET Framework 3.x
dotnetframeworklegacy_dirname = "Microsoft DotNet Framework Legacy - 20H2"
dotnetframeworklegacy_inst = "microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab"