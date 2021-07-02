# Build with nix
*Note that even though nix is used, the resulting binary won't be dependent on
the nix system*

The nix flake will build the ginkou javascript and place it in the current
directory. It will also fetch the ginkou-loader and melwalletd sources to the
current directory. Versions of the projects are tracked in the nix.lock file
and can be updated through the nix flake interface.

```bash
# Open a nix shell
nix develop
docker build . --tag ginkou
```

# Build without nix
Simply clone in the three projects

```bash
git clone https://github.com/themeliolabs/ginkou
git clone https://github.com/themeliolabs/melwalletd
git clone https://github.com/themeliolabs/ginkou-loader
```

Build ginkou with npm
```bash
cd ginkou
npm install && npm build
```

Back in the root project directory
```bash
docker build . --tag ginkou
```
