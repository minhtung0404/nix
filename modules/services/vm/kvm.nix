{
  flake.modules.nixos.vm = { pkgs, config, ... }: {
    virtualisation.libvirtd.enable = true;

    users.users.${config.mtn.constants.username}.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      qemu
    ];
  };
}
