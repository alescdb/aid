# AID (ChatGPT from Command Line)

A simple command-line application written in [Dart](https://dart.dev/) to call ChatGPT from command line (linux only for now) with simple markdown to ANSI output.

# Setup

Setup file (`~/.config/aid/setup.json`):
```json
{
  "apikey": "sk-abcdef...",
  "model": "gpt-4",
  "markdown": true,
  "system": "You are a Linux coder assistant."
}
```

| name       | value                              |
|------------|------------------------------------|
| `apikey`   | OpenAI API key (required)          |
| `model`    | Set by default to `gpt-4`          |
| `markdown` | Parse markdown (default to `true`) |
| `system`   | System prompt (not required)       |

# Install

```bash
make install
```

# Usage

```bash
aid <prompt>
```

# TODO

- Chat History
- Configuration file command line parameter
- Windows & macOS support (if asked) ?!
- Arch AUR
