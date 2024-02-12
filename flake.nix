{
  description = "HDR support";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation rec {
            name = "VK_hdr_layer";
            src = self;
            outputs = [ "out" "dev" ];

            nativeBuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass xorg.libXcursor xorg.libXrandr xorg.libxkbfile xorg.libXi xorg.libXv xorg.libXvMC xorg.libXxf86vm vulkan-headers vulkan-tools vulkan-volk vk-bootstrap vulkan-utility-libraries vulkan-loader ];
            buildInputs = with pkgs; [ libadwaita ];

            enableParallelBuilding = true;

            meta = with pkgs.lib; {
              homepage = "https://github.com/ExpidusOS/libtokyo";
              license = with licenses; [ gpl3Only ];
              maintainers = [ "Tristan Ross" ];
            };
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              meson
              ninja
              pkg-config
              vala
              nodejs
              gcc
              libadwaita.dev
              libadwaita.devdoc
              xorg.libXcursor xorg.libXrandr xorg.libxkbfile xorg.libXi xorg.libXv xorg.libXvMC xorg.libXxf86vm vulkan-headers vulkan-tools vulkan-volk vk-bootstrap vulkan-utility-libraries vulkan-loader
            ];

            shellHooks = ''
              meson install -C build --destdir "$pkgdir" --skip-subprojects vkroots
              install -Dm644 LICENSE -t "$pkgdir/usr/share/licenses/$pkgname"
            '';
          };
        });
    };
}
