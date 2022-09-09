# WINDOWS 10 & 11 IMAGE CREATION WITH PACKER (HCL2 CODE LANGUAGE)
## The fundatment of the images are based on the best practices of VMware, Microsoft and Citrix
### Do note when using the images for Microsoft and Citrix. My intention to start was for an VMware Horizon environment, so the focus is there.

### Before you begin, please check the following:
- Download packer.exe (https://www.packer.io/downloads) and packer-plugin-windows-update (https://github.com/rgl/packer-plugin-windows-update/releases) and place them in the root directory of this folder;
- Place the VMware Tools - ISO file on a vSphere Datastore and check the path in the correct variable;
- Place the Windows 10/11 - ISO file on the vSphere Datastore and check the path in the correct variable;
- Change the values in the autounattend.xml files, which are marked between percentage signs %% and also the input-locale. The files can be found in: http > windows > 10/11;
- Create hashed password files via PowerShell for a Domain Join Service Account and for a new Local VDI Admin account > http > files > domjoin / localadmin;
- Filled-in all variables in the *.pkvars.hcl files, do also check the *.pkr.hcl files;
- You have an DFS/CIFS/SMB share available to function as a repository for your imaging software and configuration files. Take care that your folder names matches the variable names and this means also for the executables.

### Tips
- Just a friendly note, this setup works out for me and is intended for multi-environment (cloud) scenarios.
- If you delete hcl files in the root directory, it can be that certain variables are declared, but not used anymore. An error will be raised while running the packer.exe command!
- Windows 11 App Volumes Image is not yet created...
- For any questions or recommendations, please leave a message.

### Commands
Commands to run in a command prompt. Copy them line by line (not all together at once!).
In my setup the packer.exe and scripts are placed on D:\Git\packer, please do change to your own setup.
Change the vm_name variable to a name which suits you best.


#### Build Windows 10 Enterprise - VDI Master Image ####
```
cd D:\Git\packer
D:
set PACKER_LOG=1
set PACKER_LOG_PATH=D:\Git\packer\logs\%date:~3,2%-%date:~6,8%_%time:~0,2%.%time:~3,2%_packer_build_w10ent_vdi.log
packer build -on-error=abort -var vm_name=W10X64ICGI00 -var imageowner=%username% -timestamp-ui -force --only vsphere-iso.windows-10 -var-file="W10ENT-VDI.pkrvars.hcl" .
```

#### Build Windows 10 Enterprise VDI - App Volumes Capture VM ####
```
cd D:\Git\packer
D:
set PACKER_LOG=1
set PACKER_LOG_PATH=D:\Git\packer\logs\%date:~3,2%-%date:~6,8%_%time:~0,2%.%time:~3,2%_packer_build_w10ent_appvolcap.log
packer build -on-error=abort -var vm_name=W10X64AVCAP00 -var imageowner=%username% -timestamp-ui -force --only vsphere-iso.windows-10-appvolcap -var-file="W10ENT-APPVOLCAP.pkrvars.hcl" .
```

#### Build Windows 11 Enterprise - VDI Master Image ####
```
cd D:\Git\packer
D:
set PACKER_LOG=1
set PACKER_LOG_PATH=D:\Git\packer\logs\%date:~3,2%-%date:~6,8%_%time:~0,2%.%time:~3,2%_packer_build_w11ent_vdi.log
packer build -on-error=abort -var vm_name=W11X64ICGI00 -var imageowner=%username% -timestamp-ui -force --only vsphere-iso.windows-11 -var-file="W11ENT-VDI.pkrvars.hcl" .
```

#### Build Windows 10 Enterprise Multi-session - VDI Master Image on Azure ####
```
cd D:\Git\packer
D:
set PACKER_LOG=1
set PACKER_LOG_PATH=D:\Git\packer\logs\%date:~3,2%-%date:~6,8%_%time:~0,2%.%time:~3,2%_packer_build_w10ent_vdi_azure.log
packer build -on-error=abort -var azure_temp_compute_name=W10MSPKGRTMP -var azure_shared_image_gallery_image_version=1.0.0 -timestamp-ui -force --only azure-arm.windows-10-vdi -var-file="W10ENT-VDI-AVD-AZURE.pkrvars.hcl" .
```
