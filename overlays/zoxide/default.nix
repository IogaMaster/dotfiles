_: (final: prev: {
  zoxide = prev.zoxide.overrideAttrs {
    src = final.fetchFromGitHub {
      owner = "ajeetdsouza";
      repo = "zoxide";
      rev = "3022cf3686b85288e6fbecb2bd23ad113fd83f3b";
      hash = "sha256-ut+/F7cQ5Xamb7T45a78i0mjqnNG9/73jPNaDLxzAx8=";
    };
  };
})
