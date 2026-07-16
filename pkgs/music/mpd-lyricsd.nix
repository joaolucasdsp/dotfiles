# mpd-lyricsd (https://github.com/JakeStanger/mpd-lyricsd) isn't packaged
# in nixpkgs and isn't published to crates.io either, so it's built directly
# from the upstream repo, pinned to the latest commit at the time of
# writing (no tags exist upstream).
#
# Patched per the new-wave rice's own README instructions: write lyrics to
# a fixed lyrics.txt instead of "{artist} - {title}.txt", and drop the
# "skip if file already exists" check (which only made sense for the
# per-song filename - with a fixed name it would block ever updating the
# file again after the first song).
{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-lyricsd";
  version = "unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "mpd-lyricsd";
    rev = "a8b9830887b5d48dd594ee681e66d1f376994099";
    sha256 = "1gz9z2afw2hc2qkk7vayzqimxhamnbxzglwmj2iy82r405nf1jgd";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail \
        'let song_path = Path::new(lyrics_path).join(format!("{artist} - {title}.txt"));' \
        'let song_path = Path::new(lyrics_path).join("lyrics.txt");'

    substituteInPlace src/main.rs \
      --replace-fail \
'    if matches!(fs::try_exists(&song_path).await, Ok(true)) {
        info!("Lyrics file for '"'"'{artist} - {title}'"'"' already exists - skipping");
    } else {
        let lyrics = genius.get_lyrics(artist, title).await;

        match lyrics {
            Ok(Some(lyrics)) => {
                fs::write(&song_path, lyrics).await?;
                info!("Saved lyrics to '"'"'{}'"'"'", &song_path.display());
            }
            Ok(None) => {
                warn!("Unable to find lyrics for '"'"'{artist} - {title}'"'"'");
            }
            Err(err) => error!("{err:?}"),
        }
    };' \
'    let lyrics = genius.get_lyrics(artist, title).await;

    match lyrics {
        Ok(Some(lyrics)) => {
            fs::write(&song_path, lyrics).await?;
            info!("Saved lyrics to '"'"'{}'"'"'", &song_path.display());
        }
        Ok(None) => {
            warn!("Unable to find lyrics for '"'"'{artist} - {title}'"'"'");
        }
        Err(err) => error!("{err:?}"),
    }'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = {
    description = "Lyrics fetching service for MPD (patched: fixed lyrics.txt output)";
    homepage = "https://github.com/JakeStanger/mpd-lyricsd";
    mainProgram = "mpd-lyricsd";
  };
}
