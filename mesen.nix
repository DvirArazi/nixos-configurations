with import <nixpkgs> { };

mkShell {
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    sdl2
  ];

  shellHook = "./home/dvir/Downloads/Mesen";
}
