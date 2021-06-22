{ stdenv,
  system,
  melwalletd,
  ginkou,
  ginkou-loader
}:

stdenv.mkDerivation {
  name = "ginkou";
  inherit system;

  buildInputs = [ melwalletd ginkou ginkou-loader ];
  buildCommand = ''
    # Copy in js dependencies
    #cp -r ${ginkou}/result/lib/node_modules .

    # Create a run script
    echo ./ginkou-loader --html-path ./public --melwalletd-path ./melwalletd > run.sh

    # Copy in the binaries
    mkdir $out
    cp ${ginkou-loader}/bin/ginkou-loader $out
    cp ${melwalletd}/bin/melwalletd $out
    cp run.sh $out
    chmod 777 $out/run.sh

    # Copy in public & node_modules directories
    ls -l ${ginkou}
    cp -r ${ginkou}/* $out
  '';
}
