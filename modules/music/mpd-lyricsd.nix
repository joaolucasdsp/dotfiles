{ rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
,
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
