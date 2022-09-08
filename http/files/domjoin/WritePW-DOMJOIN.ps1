# Create a hashed password for sa-domjoin

$File = "DOMJOIN.pwd"
[Byte[]] $key = (1..16)
$Password = "Welcome1234." | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $key | Out-File $File