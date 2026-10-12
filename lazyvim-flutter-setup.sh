#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
mkdir -p "$config_dir/snippets" "$config_dir/lua/plugins"

python3 - "$config_dir" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
langs = root / "lua/plugins/langs.lua"
text = langs.read_text()
dart_import = '  { import = "lazyvim.plugins.extras.lang.dart" }, -- Dart / Flutter\n'
if dart_import not in text:
    text = text.replace(
        '  { import = "lazyvim.plugins.extras.lang.clangd" }, -- C / C++ (clangd)\n',
        '  { import = "lazyvim.plugins.extras.lang.clangd" }, -- C / C++ (clangd)\n' + dart_import,
    )
if '        "dart",\n' not in text:
    text = text.replace('        "cpp",\n', '        "cpp",\n        "dart",\n', 1)

# Mason should not install every tool for every project at startup. Dart and
# Flutter use the SDK's dart language server and formatter, so no Mason package
# is needed for this project. Keep the other language extras available, but
# install their tools explicitly with :Mason when working in those projects.
start = text.find('      ensure_installed = {', text.find('"mason-org/mason.nvim"'))
if start != -1:
    end = text.find('      },', start)
    if end != -1:
        text = text[:start] + '      ensure_installed = {}, -- project tools are installed on demand\n' + text[end + len('      },'):]
text = text.replace('-- Install every server / tool on startup', '-- Install project tools on demand')
text = text.replace('-- Add more any time with :Mason.', '-- Add project-specific tools with :Mason.')
langs.write_text(text)

(root / "lua/plugins/flutter-snippets.lua").write_text('''return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    opts = { snippets = { preset = "luasnip" } },
  },
}
''')

snippets = {
  "Stateless widget": {
    "prefix": "fst",
    "body": [
      "class ${1:WidgetName} extends StatelessWidget {",
      "  const ${1:WidgetName}({super.key});", "", "  @override",
      "  Widget build(BuildContext context) {",
      "    return ${0:const SizedBox.shrink()};", "  }", "}"
    ], "description": "Create a Flutter StatelessWidget"
  },
  "Stateful widget": {
    "prefix": "fstate",
    "body": [
      "class ${1:WidgetName} extends StatefulWidget {",
      "  const ${1:WidgetName}({super.key});", "", "  @override",
      "  State<${1:WidgetName}> createState() => _${1:WidgetName}State();", "}", "",
      "class _${1:WidgetName}State extends State<${1:WidgetName}> {", "  @override",
      "  Widget build(BuildContext context) {",
      "    return ${0:const SizedBox.shrink()};", "  }", "}"
    ], "description": "Create a Flutter StatefulWidget"
  },
  "Stateless shorthand": {
    "prefix": "stless",
    "body": [
      "class ${1:WidgetName} extends StatelessWidget {",
      "  const ${1:WidgetName}({super.key});", "", "  @override",
      "  Widget build(BuildContext context) => ${0:const SizedBox.shrink()};", "}"
    ]
  },
  "Stateful shorthand": {
    "prefix": "stful",
    "body": [
      "class ${1:WidgetName} extends StatefulWidget {",
      "  const ${1:WidgetName}({super.key});", "", "  @override",
      "  State<${1:WidgetName}> createState() => _${1:WidgetName}State();", "}", "",
      "class _${1:WidgetName}State extends State<${1:WidgetName}> {", "  @override",
      "  Widget build(BuildContext context) => ${0:const SizedBox.shrink()};", "}"
    ]
  },
  "Scaffold": {
    "prefix": "fscaffold",
    "body": ["Scaffold(", "  appBar: AppBar(title: const Text('${1:Title}')),", "  body: ${0:const SizedBox.shrink()},", ")"]
  },
  "FutureBuilder": {
    "prefix": "ffuture",
    "body": ["FutureBuilder<${1:Type}>(", "  future: ${2:future},", "  builder: (context, snapshot) {", "    if (snapshot.connectionState == ConnectionState.waiting) {", "      return const Center(child: CircularProgressIndicator());", "    }", "    if (snapshot.hasError) return Text('Error: ${snapshot.error}');", "    return ${0:const SizedBox.shrink()};", "  },", ")"]
  },
  "StreamBuilder": {
    "prefix": "fstream",
    "body": ["StreamBuilder<${1:Type}>(", "  stream: ${2:stream},", "  builder: (context, snapshot) {", "    if (snapshot.hasError) return Text('Error: ${snapshot.error}');", "    return ${0:const SizedBox.shrink()};", "  },", ")"]
  }
}
(root / "snippets/dart.json").write_text(json.dumps(snippets, indent=2) + "\n")
(root / "snippets/package.json").write_text(json.dumps({
  "name": "personal-flutter-snippets",
  "contributes": {"snippets": [{"language": "dart", "path": "./dart.json"}]},
}, indent=2) + "\n")
PY

echo "Installed Dart/Flutter LazyVim support and snippets in $config_dir"
