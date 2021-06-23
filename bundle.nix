{ stdenv,
  system,
  melwalletd,
  ginkou,
  ginkou-loader,
}:

let
  start-script = ''
    #! /usr/bin/env bash
    SCRIPTPATH=\"\$( cd -- \"\$(dirname \"\$0\")\" >/dev/null 2>&1 ; pwd -P )\"
    \$SCRIPTPATH/ginkou-loader --html-path \$SCRIPTPATH/public --melwalletd-path \$SCRIPTPATH/melwalletd
  '';
in
stdenv.mkDerivation {
  name = "ginkou";
  inherit system start-script;

  buildInputs = [ melwalletd ginkou ginkou-loader ];
  buildCommand = ''
    # Create a run script
    #echo ./ginkou-loader --html-path ./public --melwalletd-path ./melwalletd > run.sh
    echo "${start-script}" > run.sh

    # Copy in the binaries
    mkdir $out
    cp ${ginkou-loader}/bin/ginkou-loader $out
    cp ${melwalletd}/bin/melwalletd $out
    cp run.sh $out
    chmod 777 $out/run.sh

    # Copy in public & node_modules directories
    cp -r ${ginkou}/* $out
  '';
}
