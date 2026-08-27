# ASP.NET Core + Angular Neovim Setup

## ⚠️ IMPORTANTE: Workflow para desenvolvimento

**Antes de abrir o Neovim pela primeira vez, ou após adicionar novos pacotes NuGet:**

```bash
cd ~/projects/juno/site
devenv shell
dotnet restore
dotnet build  # CRÍTICO - Gera os metadados para o LSP
nvim .
```

O OmniSharp precisa dos arquivos compilados (`.dll`) para descompilar bibliotecas e mostrar código-fonte.

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
- Added `conform.nvim` for Visual Studio-style formatting
- Configured formatters:
  - **C#**: `csharpier` (Visual Studio formatting style)
  - **TypeScript/JavaScript**: `prettier`
  - **HTML/Angular templates**: `prettier`
  - **CSS/SCSS**: `prettier`
  - **JSON**: `prettier`
- Format on save enabled
- Keybinding: `<leader>lf` - Format current buffer

### 3. **LSP Configuration** ✅
Already configured (no changes needed):
- C# LSP with enhanced navigation
- Angular LSP
- TypeScript LSP

## Required packages in your project's flake.nix

Make sure your project's `devenv.nix` or `flake.nix` includes:

```nix
{
  # For debugging
  netcoredbg  # C# debugger
  
  # For formatting
  csharpier   # C# formatter (Visual Studio style)
  nodePackages.prettier  # JS/TS/HTML/CSS formatter
  
  # For LSP (you should already have these)
  csharp-ls   # C# language server
  nodePackages.typescript-language-server
  nodePackages."@angular/language-server"
}
```

### Important: C# Metadata Support

The `csharp-ls` LSP is now configured to:
- ✅ Load library metadata on demand
- ✅ Navigate to decompiled source code of .NET libraries
- ✅ Provide better IntelliSense for external dependencies

**How it works:**
- When you use `gd` (go to definition) on a method from a library or .NET SDK, the LSP will decompile the source and show it to you
- The `csharpls-extended-lsp-nvim` plugin enhances navigation to metadata

**Note:** Make sure your project has a `.sln` or `.csproj` file in the root. The LSP uses this to understand your project structure and dependencies.

## Usage

### Preparando o projeto para LSP funcionar completamente

**IMPORTANTE:** Para o OmniSharp ter acesso aos metadados das bibliotecas e permitir navegação em código decompilado:

```bash
cd ~/projects/juno/site

# 1. Restore das dependências
dotnet restore

# 2. Build completo do projeto (CRÍTICO para metadata)
dotnet build

# 3. Agora abra o Neovim
nvim .
```

**Por que o build é necessário?**
- O OmniSharp precisa dos arquivos `.dll` compilados para descompilar o código das bibliotecas
- Sem build, o LSP não consegue acessar os metadados do .NET SDK e NuGet packages
- É o mesmo comportamento do Visual Studio - ele também precisa buildar primeiro

### Debugging
1. Set breakpoints with `<leader>dd`
2. Start debugging with `<leader>df`
3. Use `<leader>du` to toggle the debug UI
4. Step through code with `<leader>dk` (into) and `<leader>dj` (out)

### Formatting
- Auto-format on save (enabled by default)
- Manual format: `<leader>lf`
- C# files will be formatted with csharpier (Visual Studio style)
- TypeScript/HTML/CSS files will be formatted with prettier

### LSP Features
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show documentation
- `<leader>lr` - Rename
- `<leader>la` - Code actions
- `[d` / `]d` - Navigate diagnostics

## Troubleshooting

### C# LSP showing errors on .NET SDK methods

If you see errors on methods from .NET libraries (like `String.Format`, `List<T>.Add`, etc.) or basic types like `System.Object`, `System.Boolean`:

**This usually means the LSP can't find your project structure. Follow these steps:**

1. **CRITICAL: Verify project structure** 
   - Open the `.sln` file if you have one, OR
   - Open Neovim from the directory containing your `.csproj` file
   - The LSP needs to start from a directory with `.sln` or `.csproj`

2. **Restore NuGet packages**
   ```bash
   cd ~/projects/juno/site  # Your project root
   dotnet restore
   dotnet build  # Build to ensure everything is resolved
   ```

3. **Restart LSP in Neovim**
   ```vim
   :LspRestart
   ```

4. **Check LSP root directory**
   ```vim
   :LspInfo
   ```
   Look for "Root directory" - it should point to your project folder with `.sln` or `.csproj`

5. **Wait for indexing** - First time can take 1-2 minutes. Watch the LSP status in the bottom right.

**If still not working:**
- Make sure you're running Neovim from inside `devenv shell` or `nix develop`
- Check if `csharp-ls` can find the .NET SDK: `csharp-ls --version`
- Try opening a C# file AFTER the solution/project file is recognized

### Metadata navigation not working

If `gd` doesn't navigate to library source code or shows empty files:

1. **BUILD YOUR PROJECT FIRST** (most common issue):
   ```bash
   dotnet clean
   dotnet restore
   dotnet build
   ```

2. Make sure `omnisharp-extended-lsp-nvim` plugin is loaded (check with `:checkhealth`)

3. Restart OmniSharp: `:LspRestart`

4. Check if build artifacts exist:
   ```bash
   ls bin/Debug/  # Should have .dll files
   ```

5. OmniSharp takes longer to index than csharp-ls (30s - 2min for large projects)

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
    csharpier
    nodePackages.prettier
  ];
}
```

Then run: `devenv shell` or configure `direnv`.
