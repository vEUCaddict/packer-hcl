# Create a hashed local admin password

$File = "LOCADM.pwd"
[Byte[]] $key = (1..16)
$Password = "Welcome1234." | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $key | Out-File $File