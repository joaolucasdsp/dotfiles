{ pkgs, ... }:

let 
  jq = "${pkgs.jq}/bin/jq";
  bw = "${pkgs.bitwarden-cli}/bin/bw";
  gpg = "${pkgs.gnupg}/bin/gpg";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "loadgpg" ''
      ${bw} login --apikey
      key=$(${bw} unlock --raw)

      private=~/private.gpg
      public=~/public.gpg

      ${bw} get item GPG_PRIV --session "$key" | ${jq} -r '.notes' >> "$private"

      ${bw} get item GPG_PUB --session "$key" | ${jq} -r '.notes' > "$public"

      ${bw} lock

      ${gpg} --import $public
      ${gpg} --import $private

      rm $public
      rm $private

      echo "GPG key imported!"
    '')
  ];
}
