let
  pkgs = import <nixpkgs> {};
  name = "pip-env";
  venvDir = "./.venv";
in with pkgs; mkShell rec {
  inherit name venvDir;

  buildInputs = [
    python27
    python27Packages.pip
    python27Packages.setuptools
    python27Packages.virtualenv # Needed when using python 2.7
    python27Packages.wheel
    postgresql_9_6
  ];

  # This is very close to how venvShellHook is implemented, but
  # adapted to use 'virtualenv'
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)

    if [ -d "${venvDir}" ]; then
      printf "%s\n" "Skipping venv creation, '${venvDir}' already exists"
    else
      printf "%s\n" "Creating new venv environment in path: '${venvDir}'"
      # Note that the module venv was only introduced in python 3, so for 2.7
      # this needs to be replaced with a call to virtualenv
      ${python27Packages.virtualenv}/bin/virtualenv "${venvDir}"
    fi

    # Under some circumstances it might be necessary to add your virtual
    # environment to PYTHONPATH, which you can do here too;
    PYTHONPATH=$PWD/${venvDir}/${python27Packages.python.sitePackages}/:$PYTHONPATH

    source "${venvDir}/bin/activate"

    # As in the previous example, this is optional.
    pip install -r requirements.txt
  '';
}
