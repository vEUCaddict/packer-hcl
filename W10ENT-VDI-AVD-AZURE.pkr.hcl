# https://www.packer.io/plugins/builders/azure

# Local section
locals {
  azure_temp_compute_name = "${var.azure_temp_compute_name}"
  azure_shared_image_gallery_image_version = "${var.azure_shared_image_gallery_image_version}"
}

# Source section
source "azure-arm" "windows-10-vdi" {

  # Azure VM configuration
  client_id = "${var.azure_client_id}"
  client_secret = "${var.azure_client_secret}"
  tenant_id= "${var.azure_tenant_id}"
  subscription_id = "${var.azure_subscription_id}"

  temp_resource_group_name = "${var.azure_temp_resource_group_name}"
  temp_compute_name = local.azure_temp_compute_name
  temp_nic_name = local.azure_temp_compute_name
  temp_os_disk_name = local.azure_temp_compute_name  
  
  os_type = "${var.azure_os_type}"
  image_publisher = "${var.azure_image_publisher}"
  image_offer = "${var.azure_image_offer}"
  image_sku = "${var.azure_image_sku}"

  virtual_network_name = "${var.azure_virtual_network_name}"
  virtual_network_subnet_name = "${var.azure_virtual_network_subnet_name}"
  virtual_network_resource_group_name = "${var.azure_resource_group_name}"

  shared_image_gallery_destination {
    subscription = "${var.azure_subscription_id}"
    resource_group = "${var.azure_resource_group_name}"
    gallery_name = "${var.azure_shared_image_gallery_name}"
    image_name = "${var.azure_shared_image_gallery_image_name}"
    image_version = local.azure_shared_image_gallery_image_version
    replication_regions = ["westus"]
  }

  managed_image_resource_group_name = "${var.azure_resource_group_name}"
  managed_image_name = "${var.azure_managed_image_name}"

  communicator = "${var.packer_communicator}"
  winrm_use_ssl = true
  winrm_insecure = true
  winrm_timeout = "${var.winrm_timeout}"
  winrm_username = "${var.winrm_username}"
  winrm_password = "${var.winrm_password}"
  location = "${var.azure_location}"
  vm_size = "${var.azure_vm_size}"
}


# Build section
build {
  sources = ["source.azure-arm.windows-10-vdi",]

  # STAGE 1) POST OS CONFIG
  provisioner "powershell" {
    elevated_user = var.winrm_username
    elevated_password = var.winrm_password
    inline = [
      "Write-Host \"Creating temporary imaging folders...\"",
      "New-Item -Path 'C:\\' -Name 'PackerTemp' -ItemType 'Directory' | Out-Null",
      "New-Item -Path 'C:\\PackerTemp' -Name 'Software' -ItemType 'Directory' | Out-Null",
      "New-Item -Path 'C:\\PackerTemp' -Name 'PSFunctions' -ItemType 'Directory' | Out-Null",
      "New-Item -Path 'C:\\PackerTemp' -Name 'Drivers' -ItemType 'Directory' | Out-Null",
      "if( -not (Test-Path -Path 'C:\\PackerTemp\\OEM' ) ) { New-Item -Path 'C:\\PackerTemp\\OEM' -ItemType Directory | Out-Null }",
      "New-Item -Path 'C:\\Windows' -Name 'CleanUp' -ItemType 'Directory' | Out-Null",
      "Write-Host \"Add \"${var.dnssuffixlist}\" to the DNS SuffixList...\"",
      "Set-DnsClientGlobalSetting -SuffixSearchList \"${var.dnssuffixlist}\" -Confirm:$false | Out-Null",
      "Write-Host \"Set Receive updates for other Microsoft products when you update Windows to On...\"",
      "(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2(\"7971f918-a847-4430-9279-4a52d1efe18d\", 7, \"\") | Out-Null",
    ]
  }

  provisioner "file" {
    source = "./http/files/certificates/${var.rootca}"
    destination = "${var.certs_path}\\${var.rootca}"
  }

  provisioner "file" {
    source = "./http/files/oem/OEMLogo.bmp"
    destination = "C:\\Windows\\OEM\\OEMLogo.bmp"
  }

  provisioner "file" {
    source = "./http/files/staging/Seal-VDI-Base-Image.cmd"
    destination = "C:\\Windows\\CleanUp\\Seal-VDI-Base-Image.cmd"
  }

  provisioner "file" {
    source = "./http/scripts/windows/functions/InstallMSI.ps1"
    destination = "${var.psfunction_path}\\InstallMSI.ps1"
  }

  provisioner "file" {
    source = "./http/scripts/windows/functions/Test-RegistryValue.ps1"
    destination = "${var.psfunction_path}\\Test-RegistryValue.ps1"
  }

  provisioner "powershell" {
    elevated_user = var.winrm_username
    elevated_password = var.winrm_password
    environment_vars = [
      "vmname=${var.vm_name}",
      "username=${var.username}",
      "password=${var.password}",
      "winrm_username=${var.winrm_username}",
      "winrm_password=${var.winrm_password}",
      "uuid=${local.uuid}",
      "organization_name=${var.organization_name}",
      "support_hours=${var.support_hours}",
      "support_phone_number=${var.support_phone_number}",
      "support_url=${var.support_url}",
      "target_release_version=${var.target_release_version}",
      "softwarerepo=${var.softwarerepo}",
      "tempsoft_path=${var.tempsoft_path}",
      "psfunction_path=${var.psfunction_path}",
      "tempdriver_path=${var.tempdriver_path}",
      "certs_path=${var.certs_path}",
      "rootca=${var.rootca}",
      "dotnetframeworklegacy_dirname=${var.dotnetframeworklegacy_dirname}",
      "dotnetframeworklegacy_inst=${var.dotnetframeworklegacy_inst}",
      "printer1_ipaddr=${var.printer1_ipaddr}",
      "printerdriver1_dirname=${var.printerdriver1_dirname}",
      "printerdriver1_inf=${var.printerdriver1_inf}",
      "printerdriver1_name=${var.printerdriver1_name}",
      "printer1_name=${var.printer1_name}",
      "printer2_ipaddr=${var.printer2_ipaddr}",
      "printerdriver2_dirname=${var.printerdriver2_dirname}",
      "printerdriver2_inf=${var.printerdriver2_inf}",
      "printerdriver2_name=${var.printerdriver2_name}",
      "printer2_name=${var.printer2_name}",
      "dutchlp_dirname=${var.dutchlp_dirname}",
    ]
    scripts = [
      "./http/scripts/windows/universal/001_Enable_AutoLogon.ps1",
      "./http/scripts/windows/universal/002_Import-LNS-RootCA.ps1",
      "./http/scripts/windows/universal/003_SetPSSecProTLS1.2.ps1",
      "./http/scripts/windows/universal/004_OEMInfo.ps1",
      "./http/scripts/windows/universal/005_NetFXCompile.ps1",
      "./http/scripts/windows/vdi/stage1/100_Optimize_VDI_Performance.ps1",
      "./http/scripts/windows/vdi/stage1/101_Windows_Features.ps1",
      "./http/scripts/windows/vdi/stage1/102_Hide_Most_Items_in_Sec_Center.ps1",
      "./http/scripts/windows/vdi/stage1/103_Remove_All_Default_Printers.ps1",
      "./http/scripts/windows/vdi/stage1/104_Install_Corporate_Printer_Drivers.ps1",
      "./http/scripts/windows/vdi/stage1/105_Install_Corporate_Fonts.ps1",
      "./http/scripts/windows/vdi/stage1/110_Install_NL_LanguagePack_and_Features.ps1",
      "./http/scripts/windows/vdi/stage1/116_Add_Languages_to_Settings.ps1",
      "./http/scripts/windows/vdi/stage1/117_Add_Language_Features_to_Settings.ps1",
    ]
  }


  provisioner "windows-restart" {
    
  }


  # STAGE 2) INSTALL OF MASTER IMAGE APPS
  provisioner "powershell" {
    elevated_user = var.winrm_username
    elevated_password = var.winrm_password
    environment_vars = [
      "username=${var.username}",
      "password=${var.password}",
      "winrm_username=${var.winrm_username}",
      "winrm_password=${var.winrm_password}",
      "softwarerepo=${var.softwarerepo}",
      "tempsoft_path=${var.tempsoft_path}",
      "psfunction_path=${var.psfunction_path}",
      "vc_redist2005sp1_x86_dirname=${var.vc_redist2005sp1_x86_dirname}",
      "vc_redist2005sp1_x64_dirname=${var.vc_redist2005sp1_x64_dirname}",
      "vc_redist2008sp1_x86_dirname=${var.vc_redist2008sp1_x86_dirname}",
      "vc_redist2008sp1_x64_dirname=${var.vc_redist2008sp1_x64_dirname}",
      "vc_redist2010sp1_x86_dirname=${var.vc_redist2010sp1_x86_dirname}",
      "vc_redist2010sp1_x64_dirname=${var.vc_redist2010sp1_x64_dirname}",
      "vc_redist2012u4_x86_dirname=${var.vc_redist2012u4_x86_dirname}",
      "vc_redist2012u4_x64_dirname=${var.vc_redist2012u4_x64_dirname}",
      "vc_redist2013u5_x86_dirname=${var.vc_redist2013u5_x86_dirname}",
      "vc_redist2013u5_x64_dirname=${var.vc_redist2013u5_x64_dirname}",
      "dotnet_framework_48_dirname=${var.dotnet_framework_48_dirname}",
      "office_365_dirname=${var.office_365_dirname}",
      "office_365_confinst=${var.office_365_confinst}",
      "teams_dirname=${var.teams_dirname}",
      "bginfo_dirname=${var.bginfo_dirname}",
      "bginfo_conffile=${var.bginfo_conffile}",
      "powershell_dirname=${var.powershell_dirname}",
      "greenshot_dirname=${var.greenshot_dirname}",
      "greenshot_inst=${var.greenshot_inst}",
      "greenshot_conffile=${var.greenshot_conffile}",
      "acrobat_reader_dc_dirname=${var.acrobat_reader_dc_dirname}",
      "acrobat_reader_dc_patch_filename=${var.acrobat_reader_dc_patch_filename}",
      "vlc_player_dirname=${var.vlc_player_dirname}",
      "sevenzip_dirname=${var.sevenzip_dirname}",
      "java_re_x86_dirname=${var.java_re_x86_dirname}",
      "java_re_x64_dirname=${var.java_re_x64_dirname}",
      "java_re_version=${var.java_re_version}",
      "edge_enterprise_dirname=${var.edge_enterprise_dirname}",
      "edge_enterprise_version=${var.edge_enterprise_version}",
      "chrome_enterprise_dirname=${var.chrome_enterprise_dirname}",
      "firefox_enterprise_dirname=${var.firefox_enterprise_dirname}",
    ]
    scripts = [
      "./http/scripts/windows/apps/201_Install_VC_Redist2005_x86.ps1",
      "./http/scripts/windows/apps/202_Install_VC_Redist2005_x64.ps1",
      "./http/scripts/windows/apps/203_Install_VC_Redist2008_x86.ps1",
      "./http/scripts/windows/apps/204_Install_VC_Redist2008_x64.ps1",
      "./http/scripts/windows/apps/205_Install_VC_Redist2010_x86.ps1",
      "./http/scripts/windows/apps/206_Install_VC_Redist2010_x64.ps1",
      "./http/scripts/windows/apps/207_Install_VC_Redist2012_x86.ps1",
      "./http/scripts/windows/apps/208_Install_VC_Redist2012_x64.ps1",
      "./http/scripts/windows/apps/209_Install_VC_Redist2013_x86.ps1",
      "./http/scripts/windows/apps/210_Install_VC_Redist2013_x64.ps1",
      "./http/scripts/windows/apps/218_Install_.NET_Framework_4.8.ps1",
      "./http/scripts/windows/apps/219_Install_Microsoft_Office_365.ps1",
      "./http/scripts/windows/apps/220_Install_Microsoft_Teams.ps1",
      "./http/scripts/windows/apps/221_Install_Microsoft_BGinfo.ps1",
      "./http/scripts/windows/apps/227_Install_Greenshot.ps1",
      "./http/scripts/windows/apps/228_Install_Adobe_Acrobat_Reader_DC.ps1",
      "./http/scripts/windows/apps/229_Install_VideoLAN_VLC_Player.ps1",
      "./http/scripts/windows/apps/230_Install_7-Zip.ps1",
      "./http/scripts/windows/apps/233_Install_Oracle_JavaRE_x86.ps1",
      "./http/scripts/windows/apps/234_Install_Oracle_JavaRE_x64.ps1",
      "./http/scripts/windows/apps/270_Install_Microsoft_Edge_Enterprise.ps1",
      "./http/scripts/windows/apps/271_Install_Google_Chrome_Enterprise.ps1",
      "./http/scripts/windows/apps/272_Install_Mozilla_Firefox_Enterprise.ps1",
    ]
  }


  provisioner "powershell" {
    elevated_user = var.winrm_username
    elevated_password = var.winrm_password
    inline = [
      "Write-Host \"Temporary enable automatic updates to enable retreiving updates of other Microsoft Products...\"",
      "Set-ItemProperty -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU\" -Name \"NoAutoUpdate\" -Value \"0\" | Out-Null",
    ]
  }
  
  
  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
  }


  provisioner "windows-restart" {

  }

  
  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
  }


  # STAGE 3) HORIZON SUITE CONFIG & AGENTS
    provisioner "powershell" {
    elevated_user = var.winrm_username
    elevated_password = var.winrm_password
    environment_vars = [
      "username=${var.username}",
      "password=${var.password}",
      "softwarerepo=${var.softwarerepo}",
      "tempsoft_path=${var.tempsoft_path}",
      "psfunction_path=${var.psfunction_path}",
      "vmwareosot_dirname=${var.vmwareosot_dirname}",
      "vmwareosot_inst=${var.vmwareosot_inst}",
      "vmwareosot_tempxml=${var.vmwareosot_tempxml}",      
      "w10_startlayout_dirname=${var.w10_startlayout_dirname}",
      "w10_startlayout_xmlfile=${var.w10_startlayout_xmlfile}",
      "horizon_daas_agent_dirname=${var.horizon_daas_agent_dirname}",
      "horizon_client_dirname=${var.horizon_client_dirname}",
    ]
    scripts = [
      "./http/scripts/windows/vdi/stage3/300_Run_VMware_OS_Optimization_Tool.ps1",
      "./http/scripts/windows/vdi/stage3/301_Import_W10_StartLayout.ps1",
      "./http/scripts/windows/vdi/stage3/302_Uninstall_Windows_UWP_Apps.ps1",
      "./http/scripts/windows/vdi/stage3/303_Install_HorizonDaaSAgent.ps1",
      "./http/scripts/windows/vdi/stage3/305_Install_HorizonClient.ps1",
    ]
  }

  
  provisioner "windows-restart" {

  }  

  
  # STAGE 4) CLEANING THE IMAGE
  provisioner "powershell" {
    elevated_user = var.winrm_username
    elevated_password = var.winrm_password
    environment_vars = [
      "username=${var.username}",
      "password=${var.password}",
      "psfunction_path=${var.psfunction_path}",
    ]
    scripts = [
      "./http/scripts/windows/vdi/stage4/400_Disable_ScheduledTasks_at_Login.ps1",
      "./http/scripts/windows/vdi/stage4/401_Disable_Autologon.ps1",
      "./http/scripts/windows/vdi/stage4/410_Prep_and_Cleanup_for_Provisioning.ps1",
      "./http/scripts/windows/vdi/stage4/499_Run_Sysprep_on_Azure_VM.ps1",
    ]
  }

}