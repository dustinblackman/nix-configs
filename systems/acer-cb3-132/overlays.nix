self: super:

{
  xkeyboard_config = super.xkeyboard_config.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      owner = "GalliumOS";
      repo = "xkeyboard-config";
      rev = "10f5fe726c367ede4a89b2ef91a9366b15bcee4e";
      sha256 = "1xd2lwsvk0ixsj7grjjabhn68ig3vsx6hdggii5ybg5lg89sj0sq";
    };
  });
}

