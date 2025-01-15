{
  description = "A simple NixOS flake";

  inputs = {
  	nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  	nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  	
	home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = inputs @ { 
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ... 
  } : {
  	nixosConfigurations.g14 = nixpkgs.lib.nixosSystem {
  	  system = "x86_64-linux";
  	  specialArgs = { inherit inputs; };
  	  
  	  modules = [
  	    ./devices/g14

  	  	home-manager.nixosModules.home-manager {
  	  	  home-manager.useGlobalPkgs = true;
  	  	  home-manager.useUserPackages = true;
		  home-manager.users.deirn = import ./home;
  	  	}
  	  ];
  	};
  };
}
