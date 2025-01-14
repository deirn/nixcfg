{
  networking = {
  	hostName = "nixos"; # Define your hostname.

  	# Configure network proxy if necessary
  	# wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  	# proxy.default = "http://user:password@proxy:port/";
  	# proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  	networkmanager = {
  	  enable = true;
  	  insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
  	};
  };
}