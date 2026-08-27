{ lib
, fetchurl
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "free-claude-code";
  version = "4.11.4";
  pyproject = true;

  rev = "36bb28255892c6f6a20ff801e493bc7b10cd9925";
  src = fetchurl {
    name = "free-claude-code-${rev}.tar.gz";
    url = "https://github.com/Alishahryar1/free-claude-code/archive/${rev}.tar.gz";
    hash = "sha256-GJh7W6eEwEiI3zMRBRJSSMKGHe9QPNWLsrQVSBmW+BI=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiohttp
    discordpy
    fastapi
    google-auth
    httpx
    jsonschema
    loguru
    markdown-it-py
    openai
    pydantic
    pydantic-settings
    python-dotenv
    python-telegram-bot
    requests
    tiktoken
    uvicorn
  ]
  ++ httpx.optional-dependencies.socks
  ++ google-auth.optional-dependencies.requests
  ++ requests.optional-dependencies.socks;

  pythonRelaxDeps = [
    "discord.py"
    "fastapi"
    "markdown-it-py"
    "openai"
    "pydantic-settings"
    "python-telegram-bot"
    "tiktoken"
    "uvicorn"
  ];

  postInstall = ''
    install -Dm444 .env.example \
      "$out/share/free-claude-code/env.example"
  '';

  pythonImportsCheck = [ "free_claude_code" ];

  meta = {
    description = "Anthropic-compatible proxy for Claude Code and other coding agents";
    homepage = "https://github.com/Alishahryar1/free-claude-code";
    license = lib.licenses.mit;
    mainProgram = "fcc-server";
    platforms = lib.platforms.unix;
  };
}
