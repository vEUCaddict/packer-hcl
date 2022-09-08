# Global variables (declaration)

variable "datetime" {
  type = string
  default = ""
  description = "Gives you the current date and time."
}

variable "date" {
  type = string
  default = "" 
  description = "Gives you the current date."
}

variable "uuid" {
  type = string
  default = ""
  description = "Generates a random UUID for the virtual machine image."
}

variable "imageowner" {
  default = ""
  description = "The username which creates the virtual machine image."
}


# VMware vCenter generic variables
variable "vcenter_server" {
  default = ""
  description = "The vCenter server hostname, IP, or FQDN. For VMware Cloud on AWS, this should look like: 'vcenter.sddc-[ip address].vmwarevmc.com'."
}

variable "username" {
  default = ""
  description = "The username for authenticating to vCenter."
}

variable "password" {
  default = ""
  description = "The plaintext password for authenticating to vCenter."
}

variable "insecure_connection" {
  default = ""
  description = "If true, does not validate the vCenter server's TLS certificate."
}

variable "datacenter" {
  default = ""
  description = "The vSphere datacenter name. Required if there is more than one datacenter in vCenter."
}

# VMware VM generic variables
variable "cluster" {
  default = ""
  description = "The vSphere cluster where the target VM is created."
}

variable "host" {
  default = ""
  description = "The ESXi host where target VM is created. A full path must be specified if the host is in a host folder. If using DRS, then ESXi Host can be empty."
}

variable "resource_pool" {
  default = ""
  description = "The vSphere resource pool in which the VM will be created. If there are no resource pool, leave it empty."
}

variable "folder" {
  default = ""
  description = "The VM folder in which the VM template will be created."
}

variable "vm_name" {
  default = ""
  description = "The vCenter virtual machine name."
}

variable "vm_version" {
  default = ""
  description = "The VM virtual hardware version."
}

variable "guest_os_type" {
  default = ""
  description = "The VM Guest OS type."
}

variable "vcpu" {
  default = ""
  description = "The amount of vCPU's."
}

variable "vcpu_cores" {
  default = ""
  description = "The amount of vCPU cores."
}

variable "vtram" {
  default = ""
  description = "The amount of virtual memory."
}

variable "svga_displays" {
  default = ""
  description = "The number of virtual displays."
}

variable "vdram" {
  default = ""
  description = "The amount of video memory."
}

variable "vgpu_profile" {
  default = ""
  description = "vGPU profile for accelerated graphics. See NVIDIA GRID vGPU documentation for examples of profile names. Defaults to none."
}

variable "datastore" {
  default = ""
  description = "The vSAN, VMFS, or NFS datastore for virtual disk and ISO file storage. Required for clusters, or if the target host has multiple datastores."
}

variable "os_disk_size" {
  default = ""
  description = "The amount of OS disk size in MB's."
}

variable "disk_controller_type" {
  default = ""
  description = "The virtual disk controller type."
}

variable "network" {
  default = ""
  description = "The network segment or port group name to which the primary virtual network adapter will be connected. A full path must be specified if the network is in a network folder."
}

variable "notes" {
  default = ""
  description = "Sets the virtual machine notes field."
}

variable "iso_filename_vmware_tools" {
  default = ""
  description = "The file name of the VMware Tools for Windows ISO image installation media. ISOs are expected to be uploaded to the datastore in a directory/folder named 'ISO'."
}

variable "iso_filename_windows" {
  default = ""
  description = "The file name of the guest operating system ISO image installation media. ISOs are expected to be uploaded to the datastore in a directory/folder named 'ISO'."
}

variable "answer_file_subdir" {
  default = ""
  description = "The subdirectory of './http/windows/' where the Windows system preparation (sysprep) XML answer file is stored. See local.answer_file_path."
}

variable "packer_communicator" {
  default = ""
  description = "Communicators are the mechanism Packer uses to upload files, execute scripts, etc. with the machine being created. Options are: none, ssh and winrm."
}

variable "winrm_timeout" {
  default = ""
  description = "The amount of time to wait for WinRM to become available in string format. This defaults to 30m since setting up a Windows machine generally takes a long time."
}

variable "winrm_username" {
  default = ""
  description = "The username to use to authenticate over WinRM-HTTPS."
}

variable "winrm_password" {
  default = ""
  description = "The plaintext password to use to authenticate over WinRM-HTTPS."
}

variable "create_snapshot" {
  description = "A boolean value true or false if you want to make a snapshot after provisioning."
  type = bool
  default = "false"
}

variable "snapshot_name" {
  description = "The name of the first snapshot after provisioning is ready."
  type = string
  default = ""
}

variable "vm_description" {
  description = "The VM image content."
  type = string
  default = ""
}


# Image template variables
variable "organization_name" {
  default = ""
  description = "Enter your organization name."
}

variable "support_hours" {
  default = ""
  description = "Enter your support hours."
}

variable "support_phone_number" {
  default = ""
  description = "Enter your support phonenumber."
}

variable "support_url" {
  default = ""
  description = "Enter your support url/hyperlink."
}

variable "domainname" {
  description = "Specify the fully qualified domain name."
  type = string
  default = ""
}

variable "dnssuffixlist" {
  description = "Specify the DNS Suffix list."
  type = string
  default = ""
}

# App Volumes Capture VM related variables
variable "appvolcapou" {
  default = ""
  description = "The Active Directory Organizational Unit where the App Volumes Capture VM must be placed."
}


# Printer related variables
variable "printer1_ipaddr" {
  default = ""
  description = "The corporate color printer ip-address."
}

variable "printerdriver1_dirname" {
  default = ""
  description = "The corporate color printer driver - Directory name."
}

variable "printerdriver1_inf" {
  default = ""
  description = "The corporate color printer driver - Driver file name."
}

variable "printerdriver1_name" {
  default = ""
  description = "The corporate color printer driver name."
}

variable "printer1_name" {
  default = ""
  description = "The corporate color printer name."
}

variable "printer2_ipaddr" {
  default = ""
  description = "The corporate black and white printer ip-address."
}

variable "printerdriver2_dirname" {
  default = ""
  description = "The corporate black and white printer driver - Directory name."
}

variable "printerdriver2_inf" {
  default = ""
  description = "The corporate black and white printer driver - Driver file name."
}

variable "printerdriver2_name" {
  default = ""
  description = "The corporate black and white printer driver name."
}

variable "printer2_name" {
  default = ""
  description = "The corporate black and white printer name."
}


# Application related variables
variable "softwarerepo" {
  default = ""
  description = "The root location where the software resides."
}

variable "tempsoft_path" {
  default = ""
  description = "Temporary location to store the software."
}

variable "dotnetframeworklegacy_dirname" {
  default = ""
  description = "Microsoft .NET Framework 3.x - Directory name of the software in the software repository."
}

variable "dotnetframeworklegacy_inst" {
  default = ""
  description = "Microsoft .NET Framework 3.x - CAB"
}

variable "vmwareosot_dirname" {
  default = ""
  description = "VMware OS Optimization Tool - Directory name of the software in the software repository."
}

variable "vmwareosot_inst" {
  default = ""
  description = "VMware OS Optimization Tool - EXE"
}

variable "vmwareosot_tempxml" {
  default = ""
  description = "VMware OS Optimization Tool - Template XML"
}

variable "dutchlp_dirname" {
  default = ""
  description = "Windows 10 - Dutch Language Pack - Directory name of the software in the software repository."
}

variable "vc_redist2005sp1_x86_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2005 SP1 (x86) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2005sp1_x64_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2005 SP1 (x64) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2008sp1_x86_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2008 SP1 (x86) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2008sp1_x64_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2008 SP1 (x64) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2010sp1_x86_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2010 SP1 (x86) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2010sp1_x64_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2010 SP1 (x64) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2012u4_x86_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2012 Update 4 (x86) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2012u4_x64_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2012 Update 4 (x64) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2013u5_x86_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2013 Update 5 (x86) Redistributable - Directory name of the software in the software repository."
}

variable "vc_redist2013u5_x64_dirname" {
  default = ""
  description = "Microsoft Visual C++ 2013 Update 5 (x64) Redistributable - Directory name of the software in the software repository."
}

variable "dotnet_framework_48_dirname" {
  default = ""
  description = "Microsoft .NET Framework 4.8 - Directory name of the software in the software repository."
}

variable "office_365_dirname" {
  default = ""
  description = "Microsoft Office 365 Apps for Enterprise - Directory name of the software in the software repository."
}

variable "office_365_confinst" {
  default = ""
  description = "Microsoft Office 365 Apps for Enterprise - Installer configuration XML file."
}

variable "teams_dirname" {
  default = ""
  description = "Microsoft Teams - Directory name of the software in the software repository."
}

variable "bginfo_dirname" {
  default = ""
  description = "Microsoft BGInfo - Directory name of the software in the software repository."
}

variable "bginfo_conffile" {
  default = ""
  description = "Microsoft BGInfo - Configuration file name."
}

variable "powershell_dirname" {
  default = ""
  description = "Micrsofot PowerShell - Directory name of the software in the software repository."
}

variable "acrobat_reader_dc_dirname" {
  default = ""
  description = "Adobe Acrobat Reader DC - Directory name of the software in the software repository."
}

variable "acrobat_reader_dc_patch_filename" {
  default = ""
  description = "Adobe Acrobat Reader DC - Patch file name."
}

variable "vlc_player_dirname" {
  default = ""
  description = "VideoLAN VLC Media Player - Directory name of the software in the software repository."
}

variable "sevenzip_dirname" {
  default = ""
  description = "IgorPavlov 7-zip - Directory name of the software in the software repository."
}

variable "java_re_x86_dirname" {
  default = ""
  description = "Oracle Java Runtime Environment x86 - Directory name of the software in the software repository."
}

variable "java_re_x64_dirname" {
  default = ""
  description = "Oracle Java Runtime Environment x64 - Directory name of the software in the software repository."
}

variable "java_re_version" {
  default = ""
  description = "Oracle Java Runtime Environment - Version."
}

variable "greenshot_dirname" {
  default = ""
  description = "Greenshot - Directory name of the software in the software repository."
}

variable "greenshot_inst" {
  default = ""
  description = "Greenshot - Installer file name."
}

variable "greenshot_conffile" {
  default = ""
  description = "Greenshot - Configuration file name."
}

variable "edge_enterprise_dirname" {
  default = ""
  description = "Microsoft Edge Enterprise - Directory name of the software in the software repository."
}

variable "edge_enterprise_version" {
  default = ""
  description = "Microsoft Edge Enterprise - File version of msedge.exe."
}

variable "chrome_enterprise_dirname" {
  default = ""
  description = "Google Chrome Enterprise - Directory name of the software in the software repository."
}

variable "firefox_enterprise_dirname" {
  default = ""
  description = "Mozilla Firefox Enterprise - Directory name of the software in the software repository."
}

variable "horizon_agent_dirname" {
  default = ""
  description = "VMware Horizon Agent - Directory name of the software in the software repository."
}

variable "horizon_direct_con_agent_dirname" {
  default = ""
  description = "VMware Horizon Direct Connect Agent - Directory name of the software in the software repository."
}

variable "horizon_client_dirname" {
  default = ""
  description = "VMware Horizon Client - Directory name of the software in the software repository."
}

variable "horizon_daas_agent_dirname" {
  default = ""
  description = "VMware Horizon DaaS Agent - Directory name of the software in the software repository."
}

variable "dem_agent_dirname" {
  default = ""
  description = "VMware Dynamic Environment Manager (DEM) Agent - Directory name of the software in the software repository."
}

variable "dem_profiler_dirname" {
  default = ""
  description = "VMware Dynamic Environment Manager (DEM) Profiler - Directory name of the software in the software repository."
}

variable "appvol_agent_dirname" {
  default = ""
  description = "VMware App Volumes Agent - Directory name of the software in the software repository."
}

variable "appvol_mgr_fqdn" {
  default = ""
  description = "VMware App Volumes Manager - FQDN VIP ADDRESS"
}

variable "appvol_mgr_port" {
  default = ""
  description = "VMware App Volumes Manager - Communication Port"
}

variable "thinapp_dirname" {
  default = ""
  description = "VMware App Volumes Agent - Directory name of the software in the software repository."
}

# Other related variables
variable "psfunction_path" {
  default = ""
  description = "Temporary location to store PowerShell functions."
}

variable "tempdriver_path" {
  default = ""
  description = "Temporary location to store drivers."
}

variable "certs_path" {
  default = ""
  description = "Temporary location to store certificate files."
}

variable "rootca" {
  default = ""
  description = "Filename of the internal PKI RootCA."
}

variable "sadomjoin" {
  default = ""
  description = "The username of the service account (domain) which can add machines to the domain."
}

variable "localvdiadmin" {
  default = ""
  description = "The username of the new local administator account."
}

variable "w10_startlayout_dirname" {
  default = ""
  description = "Microsoft Windows - Start Menu Layout - Directory name of the software in the software repository."
}

variable "w10_startlayout_xmlfile" {
  default = ""
  description = "Microsoft Windows - Start Menu Layout - XML file name."
}

variable "w11_startlayout_dirname" {
  default = ""
  description = "Microsoft Windows - Start Menu Layout - Directory name of the software in the software repository."
}

variable "w11_startlayout_xmlfile" {
  default = ""
  description = "Microsoft Windows - Start Menu Layout - XML file name."
}

variable "target_release_version" {
  default = ""
  description = " Microsoft Windows - On which OS version it needs to stay."
}


# Azure generic variables
variable "azure_client_secret" {
  type =  string
  default = ""
  description = "Azure AD > App Registrations > Packer specified app > Certificates & secrets section. (can be found in password save)"
  // Sensitive vars are hidden from output as of Packer v1.6.5
  sensitive = false
}

variable "azure_client_id" {
  type =  string
  default = ""
  description = "Azure AD > App Registrations > Packer specified app > Overview section."
  // Sensitive vars are hidden from output as of Packer v1.6.5
  sensitive = false
}

variable "azure_tenant_id" {
  type = string
  default = ""
  description = "Azure AD > App Registrations > Packer specified app > Overview section."
}

variable "azure_subscription_id" {
  type = string
  default = ""
  description = "Subscriptions > Your Own Azure Subscription > Overview section."
}

variable "azure_resource_group_name" {
  default = ""
  description = ""
}

variable "azure_os_type" {
  default = ""
  description = ""
}

variable "azure_image_publisher" {
  default = ""
  description = ""
}

variable "azure_image_offer" {
  default = ""
  description = ""
}

variable "azure_image_sku" {
  default = ""
  description = ""
}

variable "azure_location" {
  default = ""
  description = ""
}

variable "azure_vm_size" {
  default = ""
  description = ""
}

variable "azure_virtual_network_name" {
  default = ""
  description = ""
}

variable "azure_virtual_network_subnet_name" {
  default = ""
  description = ""
}

variable "azure_shared_image_gallery_name" {
  default = ""
  description = ""
}

variable "azure_shared_image_gallery_image_name" {
  default = ""
  description = ""
}

variable "azure_shared_image_gallery_image_version" {
  default = ""
  description = ""
}

variable "azure_replication_regions" {
  default = ""
  description = ""
}

variable "azure_temp_resource_group_name" {
  default = ""
  description = ""
}

variable "azure_managed_image_name" {
  default = ""
  description = ""
}

variable "azure_temp_compute_name" {
  default = ""
  description = ""
}


# Plugins section
packer {
  required_version = ">= 1.7.4"
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
      # Github Plugin Repo https://github.com/rgl/packer-plugin-windows-update
    }
  }
}