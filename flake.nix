{
  description = "USB cocotb testbench environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python312;
      sifiveToolchain = pkgs.stdenv.mkDerivation {
        name = "riscv64-unknown-elf-gcc-8.1.0";
        src = pkgs.fetchurl {
          url = "https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz";
          sha256 = "109lkjjfmi0kppw7ln0b671x9sila9jl0jrsr3036c8l0wnkskaz";
        };
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.zlib pkgs.python3 ];
        autoPatchelfIgnoreMissingDeps = [ "libncurses.so.5" "libtinfo.so.5" "liblzma.so.5" ];
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r . $out/
        '';
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.iverilog
          pkgs.sigrok-cli
          pkgs.surfer
          pkgs.gtkwave
          pkgs.yosys
          pkgs.python312Packages.flake8
          python
          python.pkgs.pip
          python.pkgs.virtualenv
          sifiveToolchain
        ];

        shellHook = ''
          if [ ! -f usb-test-suite-testbenches/Makefile ]; then
            echo "WARNING: submodules not initialized. Run: git submodule update --init --recursive"
          fi
          if [ ! -d env ]; then
            python3.12 -m venv env
            . env/bin/activate
            pip install "cocotb>=2.0" cocotb-bus "migen @ git+https://github.com/m-labs/migen.git@147f003fb7076ac4c7cf76a9a5ce152dc10e0ca6" pytest pythondata-cpu-picorv32 pythondata-cpu-vexriscv pythondata-software-compiler_rt pythondata-misc-tapcfg
            pip install -e usb-test-suite-cocotb-usb/
          else
            . env/bin/activate
          fi
        '';
      };
    };
}
