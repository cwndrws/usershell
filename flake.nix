{
  description = "dev shell that uses the user's configured shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            shellHook = ''
              # Get the user's default shell from /etc/passwd
              user_shell="$(awk -F: -v user="$(whoami)" '$1 == user {print $NF}' /etc/passwd)"

              # Check if the shell is interactive
              if [[ $- == *i* ]]; then
                echo "Starting user's default shell: $user_shell"
                exec "$user_shell"
              else
                echo "Non-interactive shell detected. Using default nix-shell."
              fi
            '';
          };
        }
      );
}

