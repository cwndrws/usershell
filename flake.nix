{
  description = "dev shell that uses the user's configured shell";
  inputs = {};
  outputs = { self, ... }: {
    lib.mkUserShell = { pkgs, ... }@args:
      pkgs.mkShell ({
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
      } // builtins.removeAttrs args [ "pkgs" ] );
  };
}

