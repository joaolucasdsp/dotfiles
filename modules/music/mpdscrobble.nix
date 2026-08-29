{ buildPythonApplication
, fetchPypi
, setuptools
, httpx
, python-mpd2
, pylast
,
}:

buildPythonApplication rec {
  pname = "mpdscrobble";
  version = "0.3.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d798339a0f59dc20df7253a4989e639fa2fdbe9d0306a1a020a0df85046ca3a";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    httpx
    python-mpd2
    pylast
  ];

  doCheck = false;

  meta = {
    description = "A simple Last.fm/ListenBrainz/Maloja scrobbler for MPD";
    homepage = "https://github.com/dbeley/mpdscrobble";
    mainProgram = "mpdscrobble";
  };
}
