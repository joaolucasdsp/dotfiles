# ASP.NET Core + Angular Neovim Setup

## ⚠️ IMPORTANTE: Workflow para desenvolvimento

**Antes de abrir o Neovim pela primeira vez, ou após adicionar novos pacotes NuGet:**

```bash
cd ~/projects/juno/site
devenv shell
dotnet restore
dotnet build
nvim .
```

O `dotnet restore` é o passo CRÍTICO. O roslyn-ls carrega a solution com o MSBuild do .NET SDK que está no `PATH`. Sem `dotnet restore`, as referências NuGet não resolvem e o LSP mostra erros em tipos de bibliotecas.

---

## What was configured

### 1. **Debugging Support** ✅
- Enabled `nvim-dap` and `nvim-dap-ui` plugins
- Configured C#/.NET Core debugging with `netcoredbg`
- Debugging keybindings:
  - `<leader>dd` - Toggle breakpoint
  - `<leader>dD` - Conditional breakpoint
  - `<leader>df` - Start/continue debugging
  - `<leader>dk` - Step into
  - `<leader>dj` - Step out
  - `<leader>du` - Toggle debug UI

### 2. **Formatting Support** ✅
- `conform.nvim` formats on save
- Configured formatters:
  - **C#**: roslyn-ls, through conform's language server fallback (honors `.editorconfig`)
  - **TypeScript/JavaScript**: `prettier`
  - **HTML/Angular templates**: `prettier`
  - **CSS/SCSS**: `prettier`
  - **JSON**: `prettier`
- Keybinding: `<leader>lf` - Format current buffer

### 3. **LSP Configuration** ✅
The Neovim config installs these servers, so they work outside a project shell:
- **C#**: [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) with `roslyn-ls` (`Microsoft.CodeAnalysis.LanguageServer`), the server the VS Code C# extension uses
- **Angular templates and components**: `angular-language-server` (`ngserver`)
- **TypeScript**: `typescript-language-server`
- **HTML and CSS/SCSS**: `vscode-langservers-extracted`

A project shell wins when it provides its own copy of a server, because the Neovim config appends its servers to the end of `PATH`.

Files named `*.component.html` open as `htmlangular`, so both the Angular and the HTML servers attach to them.

## Required packages in your project's flake.nix

Make sure your project's `devenv.nix` or `flake.nix` includes these packages:
- `dotnetCorePackages.sdk_8_0`: the .NET SDK that roslyn-ls uses to load the solution
- `netcoredbg`: the C# debugger
- `nodePackages.prettier`: the JS/TS/HTML/CSS formatter

### Important: C# Metadata Support

roslyn-ls navigates into library code without extra plugins:
- ✅ `gd` on a type from a NuGet package or the .NET SDK opens its decompiled source
- ✅ Completion lists types from namespaces you have not imported yet and adds the `using`
- ✅ Diagnostics cover the whole solution, not only the open files

**Note:** Make sure your project has a `.sln`, `.slnx`, or `.csproj` file. roslyn.nvim searches upward from the open file for a solution. If the directory has more than one solution, choose one with `:Roslyn target`.

## Usage

### Preparando o projeto para LSP funcionar completamente

**IMPORTANTE:** Para o roslyn-ls resolver as bibliotecas e navegar no código decompilado:

1. Restore das dependências (CRÍTICO): `dotnet restore`
2. Build completo do projeto: `dotnet build`
3. Agora abra o Neovim: `nvim .`

**Por que o restore é necessário?**
- O roslyn-ls carrega os projetos com o MSBuild, e o MSBuild precisa do `project.assets.json` que o `dotnet restore` gera
- Sem restore, o LSP não encontra os assemblies dos pacotes NuGet e não consegue decompilar o código deles
- É o mesmo comportamento do Visual Studio - ele também faz restore antes de carregar a solution

### Debugging
1. Set breakpoints with `<leader>dd`
2. Start debugging with `<leader>df`
3. Use `<leader>du` to toggle the debug UI
4. Step through code with `<leader>dk` (into) and `<leader>dj` (out)

### Formatting
- Auto-format on save (enabled by default)
- Manual format: `<leader>lf`
- C# files are formatted by roslyn-ls
- TypeScript/HTML/CSS files are formatted with prettier

### LSP Features
- `gd` - Go to definition
- `gr` - List references
- `K` - Show documentation
- `<leader>lr` - Rename
- `<leader>la` - Code actions
- `[d` / `]d` - Navigate diagnostics

## Troubleshooting

### C# LSP showing errors on .NET SDK methods

If you see errors on methods from .NET libraries (like `String.Format`, `List<T>.Add`, etc.) or basic types like `System.Object`, `System.Boolean`:

**This usually means roslyn-ls could not load your project. Follow these steps:**

1. **CRITICAL: Verify project structure**
   - Open Neovim from a directory at or below the `.sln`, `.slnx`, or `.csproj` file
   - If there are several solutions, run `:Roslyn target` and pick one

2. **Restore NuGet packages** from your project root, for example `~/projects/juno/site`
   ```bash
   dotnet restore
   dotnet build
   ```

3. **Restart the LSP in Neovim**
   ```vim
   :lsp restart roslyn
   ```

4. **Check the LSP root directory**
   ```vim
   :checkhealth vim.lsp
   ```
   Look for the `roslyn` client and its root directory. It should point to your project folder.

5. **Wait for the project to load** - roslyn.nvim shows `Roslyn project initialization complete` when it is ready. Large solutions take 30s - 2min the first time.

**If still not working:**
- Make sure you're running Neovim from inside `devenv shell` or `nix develop`, so the project's .NET SDK is on `PATH`
- Check that the SDK is visible: `dotnet --list-sdks`

### Metadata navigation not working

If `gd` doesn't navigate to library source code or shows empty files:

1. **RESTORE YOUR PROJECT FIRST** (most common issue):
   ```bash
   dotnet restore
   dotnet build
   ```

2. Restart roslyn-ls: `:lsp restart roslyn`

3. Wait until roslyn.nvim reports that the project initialization is complete

### For devenv users

If using `devenv`, your setup in `devenv.nix` should include:

```nix
{ pkgs, ... }:

{
  languages.dotnet = {
    enable = true;
    package = pkgs.dotnetCorePackages.sdk_8_0;
  };

  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_22;
  };

  packages = with pkgs; [
    netcoredbg
    nodePackages.prettier
  ];
}
```

Then run: `devenv shell` or configure `direnv`.
