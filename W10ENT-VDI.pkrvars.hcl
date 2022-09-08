# The vSphere cluster where the target VM is created.
cluster = ""

# The ESXi host where target VM is created. A full path must be specified if the host is in a host folder. If using DRS, then ESXi Host can be empty.
host = ""

# The vSphere resource pool in which the VM will be created. If there are no resource pool, leave it empty.
resource_pool  = ""

# The vSphere VM folder in which the VM template will be created.
folder = ""

# The VM Guest OS type. (https://vdc-download.vmware.com/vmwb-repository/dcr-public/b50dcbbf-051d-4204-a3e7-e1b618c1e384/538cf2ec-b34f-4bae-a332-3820ef9e7773/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html)
guest_os_type = "windows9_64Guest"

# The vSAN, VMFS, or NFS datastore for virtual disk and ISO file storage. Required for clusters, or if the target host has multiple datastores.
datastore = ""

# The amount of vCPU's.
vcpu = 2

# The amount of vCPU cores.
vcpu_cores = 4

# The amount of virtual memory in MB's.
vtram = 6144

# The amount of OS disk size in MB's. (GB x 1024)
os_disk_size = 71680

# The virtual disk controller type.
disk_controller_type = "lsilogic-sas"

# The network segment or port group name to which the primary virtual network adapter will be connected. A full path must be specified if the network is in a network folder.
network = ""

# The file name of the guest operating system ISO image installation media. ISOs are expected to be uploaded to the datastore in a directory/folder named 'ISO'.
iso_filename_windows = "en-us_windows_10_business_editions_version_21h2_x64_dvd.iso"

# The number of virtual displays.
svga_displays = "2"

# The amount of video memory in KB's. KB Calculator = https://www.gbmb.org/mb-to-kb (Binary value) and Table = https://techzone.vmware.com/creating-optimized-windows-image-vmware-horizon-virtual-desktop#_1150978 (section 8 of Create a Virtual Machine)
vdram = 79872

# vGPU profile for accelerated graphics. Defaults to none. See NVIDIA GRID vGPU documentation for examples of profile names = https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html#configure-vmware-vsphere-vm-with-vgpu
vgpu_profile = ""

# The subdirectory of './http/windows/' where the Windows system preparation (sysprep) XML answer file is stored. See local.answer_file_path.
answer_file_subdir = "10"

# Communicators are the mechanism Packer uses to upload files, execute scripts, etc. with the machine being created. Options are: none, ssh and winrm.
packer_communicator = "winrm"

# The amount of time to wait for WinRM to become available in string format. This defaults to 30m since setting up a Windows machine generally takes a long time. Example = "1h5m2s".
winrm_timeout = "1h30m0s"

# The username to use to authenticate over WinRM-HTTPS.
winrm_username = "Administrator"

# The plaintext password to use to authenticate over WinRM-HTTPS.
winrm_password = ""

# The content of the VDI image to the VM notes.
vm_description = "OS: \n Windows 10 Enterprise x64 21H2 inc. updates up on till 08-2022. \n Base Apps: \n - 7-Zip 21.07 \n - Adobe Acrobat Reader DC inc. 10-2021 update \n - Google Chrome Enterprise 96 \n - Greenshot 1.2.10.6 \n - Microsoft .NET Framework 4.8 \n - Microsoft BGinfo 4.28 \n - Microsoft Edge Enterprise 96 \n - Microsoft Office 365 Apps for Enterprise \n - Microsoft PowerShell 7.2.1 \n - Microsoft Teams \n - Microsoft Visual C++ 2005 SP1 (x64/x86) \n - Microsoft Visual C++ 2008 SP1 (x64/x86) \n - Microsoft Visual C++ 2010 SP1 (x64/x86) \n - Microsoft Visual C++ 2012 U04 (x64/x86) \n - Microsoft Visual C++ 2013 U05 (x64/x86) \n - Microsoft Visual C++ 2015 - 2019 (x64/x86) \n - Mozilla Firefox ESR 91.4 \n - Oracle Java RE 8 U311 (x64/x86) \n - VLC media player 3.0.16 \n - VMware App Volumes Agent 2111 \n - VMware Horizon Agent 2111 \n - VMware Horizon Client 2111 \n - VMware Tools 11.3 \n - VMware DEM Agent 2111"

# The username of the new local administator account.
localvdiadmin = "LocalVDIadmin"

# Windows 10 - Start Layout
w10_startlayout_dirname = "Microsoft Windows 10 - StartLayout"
w10_startlayout_xmlfile = "LayoutModification.xml"

# Windows 10 - Target Release Version Information (on which version of the OS needs to stay).
target_release_version = "21H2"

# Windows 10 - VMware OS Optimization Tool - NOGPU Template.
vmwareosot_tempxml = "Windows-10-20H2-NOGPU-Template-v1.xml"

# Windows 10 20H2 - Dutch Language and Feature Packs
dutchlp_dirname = "Microsoft Windows 10 - 20H2 NL-LP"

# Windows 10 20H2 - Microsoft .NET Framework 3.x
dotnetframeworklegacy_dirname = "Microsoft DotNet Framework Legacy - 20H2"
dotnetframeworklegacy_inst = "microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab"