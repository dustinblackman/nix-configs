const fs = require("fs");
const path = require("path");

const OPTIONS = {
  locals: {},
  templatefile: path.join(__dirname, "./kitty.conf"), // Meh.
  vimrc: path.join(__dirname, "./vim/init.vim"),
  snapshot: path.join(__dirname, "./vim/snapshot.vim")
};

exports.vimPlugins = () => {
  const vimrc = fs.readFileSync(OPTIONS.vimrc, "utf8");
  const snapshot = fs.readFileSync(OPTIONS.snapshot, "utf8").split("\n")

  const nix_plugins = vimrc.split("\n").filter(e => e.startsWith("Plug '") && !e.includes("opt/fzf")).map(e => {
    const relative_path = e.split("'")[1];
    const name = relative_path.split("/")[1];
    const commit = snapshot.find(line => line.includes(name)).split("'")[3];

    return `{
      name = "${name}";
      path = builtins.fetchGit {
        url = "https://github.com/${relative_path}.git";
        rev = "${commit}";
      };
    }`;
  }).join("\n")

  return `
    { pkgs }: rec {
      dir = pkgs.linkFarm "cache" packages;
      packages = [
        ${nix_plugins}
      ];
    }
  `;
}

exports.template = () => {
  return new Function(`return \`${fs.readFileSync(options.templatefile, "utf8")}\`;`).call(options);
}

for (const param of process.argv.slice(3)) {
  if (!param.startsWith("--")) continue;
  const key = param.split("=")[0].substring(2);
  let value = param.split("=")[1];
  if (key === "locals") {
    value = require(value);
  }

  OPTIONS[key] = value;
}

const command = process.argv[2];
if (exports[command]) {
  console.log(exports[command]());
} else {
  console.error(`${command} does not exist`);
  process.exit(1);
}
