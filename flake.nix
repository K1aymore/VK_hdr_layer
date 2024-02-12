{
  description = "HDR support";


  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = with import nixpkgs { system = "x86_64-linux"; }; stdenv.mkDerivation rec {
      name = "VK_hdr_layer";
      src = self;
#       outputs = [ "lib" "out" ];

      nativeBuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass xorg.libXcursor xorg.libXrandr xorg.libxkbfile xorg.libXi xorg.libXv xorg.libXvMC xorg.libXxf86vm vulkan-headers vulkan-tools vulkan-volk vk-bootstrap vulkan-utility-libraries vulkan-loader ];
      buildInputs = with pkgs; [ libadwaita ];

#       buildPhase = "meson ${src} build; meson compile -C build";
#       installPhase = "ls -l src; mkdir -p $out; cp -r src $out/lib";

      meta = with pkgs.lib; {
        homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
        license = with licenses; [ mit ];
        maintainers = [ "K1aymore" ];
      };

    };


  };
}
