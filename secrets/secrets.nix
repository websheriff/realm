let
  kanto = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZmR0urfmBXLlJgQj2mMI5cEwrj5b0Ny5msoJx/Gi3x";
  sevii01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvlFkaI1nFfjmpRPnyxfmeWJ7G5lH+OoM0iR/RsrN3q";
in {
  "newtMC.age".publicKeys = [ kanto ];
  "websheriffHash.age".publicKeys = [ kanto sevii01 ];
}
