#############################################################
# ~/.Brewfile - Software Installs for MacOS                 #
#                                                           #
# Usage, run: $ brew bundle --global --file $HOME/.Brewfile #
#                                                           #
#############################################################

# Options
cask_args appdir: '~/Applications', require_sha: true

# Taps
tap 'homebrew/bundle'
tap 'homebrew/core'
tap 'homebrew/services'
tap 'blacktop/tap'
tap 'browsh-org/homebrew-browsh'
tap 'espanso/espanso'
tap 'jesseduffield/lazygit'
tap 'koekeishiya/formulae'
tap 'kdash-rs/kdash'
tap 'nwithan8/tap'

#############################################################
# Command Line                                              #
#############################################################

# CLI Essentials
brew 'git'          # Version controll
brew 'neovim'       # Text editor
brew 'ranger'       # Directory browser
brew 'tmux'         # Term multiplexer

# CLI Basics
brew 'aria2'        # Resuming download util (better wget)
brew 'bat'          # Output highlighting (better cat)
brew 'broot'        # Interactive directory navigation
brew 'ctags'        # Indexing of file info + headers
brew 'diff-so-fancy'# Readable file compares (better diff)
brew 'duf'          # Get info on mounted disks (better df)
brew 'entr'         # Run command whenever file changes
brew 'exa'          # Listing files with info (better ls)
brew 'exiftool'     # Read, write and modify exif data
brew 'fzf'          # Fuzzy file finder and filtering
brew 'hyperfine'    # Benchmarking for arbitrary commands
brew 'jdupes'       # Duplicate file finder
brew 'just'         # Powerful command runner (better make)
brew 'jq'           # JSON parser, output and query files
brew 'most'         # Multi-window scroll pager (better less)
brew 'procs'        # Advanced process viewer (better ps)
brew 'ripgrep'      # Searching within files (better grep)
brew 'rsync'        # Fast incremental file transfer
brew 'sd'           # RegEx find and replace (better sed)
brew 'thefuck'      # Auto-correct miss-typed commands
brew 'tldr'         # Community-maintained docs (better man)
brew 'tokei'        # Count lines of code (better cloc)
brew 'tree'         # Directory listings as tree structure
brew 'trash-cli'    # Record and restore removed files
brew 'watch'        # Run commands periorically
brew 'xsel'         # Copy paste access to the X clipboard
brew 'zoxide'       # Auto-learning navigation (better cd)

# CLI Monitoring and Performance Apps
brew 'bmon'         # Bandwidth utilization monitor 
brew 'ctop'         # Container metrics and monitoring
brew 'dog'          # DNS lookup client (better dig)
brew 'bpytop'       # Resource monitoring (like htop)
brew 'dua-cli'      # Disk usage analyzer and monitor (better du)
brew 'glances'      # Resource monitor + web and API
brew 'goaccess'     # Web log analyzer and viewer
brew 'gping'        # Interactive ping tool, with graph
brew 'speedtest-cli'# Command line speed test utility

# CLI Productivity Apps
brew 'aspell'       # Spell check
brew 'browsh'       # Web browser, in terminal
brew 'buku'         # Bookmark manager
brew 'cmus'         # Music player
brew 'cointop'      # Crypto prices and portfolio
brew 'ddgr'         # Web search, via DuckDuckGo
brew 'khal'         # Calendar client
brew 'mutt'         # Email client
brew 'newsboat'     # RSS / ATOM reader
brew 'pass'         # Password store
brew 'rclone'       # Manage cloud storage
brew 'task'         # Todo + task management
brew 'pcopy'        # copy/paste across machines

# CLI Development Suits
brew 'httpie'       # HTTP / API testing testing client
brew 'lazydocker'   # Full Docker management app
brew 'lazygit'      # Full Git management app
brew 'kdash'        # Kubernetes management

# CLI External Sercvices
cask 'ngrok'        # Reverse proxy for sharing localhost
brew 'tmate'        # Share a terminal session via internet
brew 'asciinema'    # Recording + sharing terminal sessions
brew 'navi'         # Browse, search, read cheat sheets

# CLI Fun
brew 'cowsay'       # Have an ASCII cow say your message
brew 'figlet'       # Output text as big ASCII art text
brew 'lolcat'       # Make console output rainbow colored
brew 'neofetch'     # Show system data and ditstro info
brew 'pipes-sh'     # Cool terminal pipe screen saver
brew 'pv'           # Pipe viewer, with animation options

#############################################################
# Software Development                                      #
#############################################################

# Development Apps
cask 'boop'           # Text transformation tool
cask 'iterm2'         # Better terminal emulator
cask 'postman'        # HTTP API testing app
cask 'sourcetree'     # Git visual client
cask 'visual-studio-code' # Code editor
cask 'warp'           # Better than iterm2

# Development Langs, Compilers, Package Managers and SDKs
brew 'gcc'            # GNU C++ compilers
brew 'go'             # Compiler for Go Lang
brew 'lua'            # Lua interpreter
brew 'luarocks'       # Package manager for Lua
brew 'node'           # Node.js
brew 'nvm'            # Switching node versions
brew 'python'         # Python interpreter
brew 'rust'           # Rust language

# DevOps
brew 'ansible'        # Automation
brew 'docker'         # Containers

# Development Utils
brew 'gh'             # Interact with GitHub PRs, issues, repos
brew 'git-extras'     # Extra git commands for common tasks
brew 'terminal-notifier' # Trigger Mac notifications from terminal
brew 'tig'            # Text-mode interface for git
brew 'ttygif'         # Generate GIF from terminal commands + output
brew 'watchman'       # Watch for changes and reload dev server

# Network and Security Testing
brew 'bettercap'      # Network, scanning and monitoring
brew 'nmap'           # Port scanning
brew 'wrk'            # HTTP benchmarking
cask 'burp-suite'     # Web security testing
cask 'owasp-zap'      # Web app security scanner
cask 'wireshark'      # Network analyzer + packet capture

# Security Utilities and Data Encryption
brew 'bcrypt'         # Encryption utility, using blowfish
brew 'borgbackup'     # Encrypted, deduplicated backups
brew 'clamav'         # Open source virus scanning suite
brew 'dnscrypt-proxy' # Proxy for using encrypted DNS
cask 'gpg-suite'      # PGP encryption for emails and files
brew 'git-crypt'      # Transparent encryption for git repos
brew 'lynis'          # Scan system for common security issues
brew 'openssl'        # Cryptography and SSL/TLS Toolkit
brew 'rkhunter'       # Search / detect potential root kits
cask 'veracrypt'      # File and volume encryption

#############################################################
# Desktop Applications                                      #
#############################################################

# Media
cask 'spotify', args: { require_sha: false } # Propietary music streaming
cask 'transmission' # Torrent client
cask 'vlc'          # Media player
brew 'pandoc'       # Universal file converter
brew 'youtube-dl'   # YouTube video downloader

# Personal Applications
cask '1password'      # Password manager (proprietary)
cask 'tresorit'       # Encrypted file backup (proprietary)
cask 'standard-notes' # Encrypted synced notes
cask 'signal'         # Link to encrypted mobile messenger
cask 'mountain-duck'  # Mount remote storage locations
cask 'protonvpn'      # Client app for ProtonVPN
cask 'vorta'          # GUI for BorgBackup

# Browsers
cask 'firefox'
cask 'chromium'
cask 'orion'

#############################################################
# MacOS-Specific Stuff                                      #
#############################################################

# Fonts
tap 'homebrew/cask-fonts'
cask 'font-fira-code'
cask 'font-hack'
cask 'font-inconsolata'
cask 'font-meslo-lg-nerd-font'

# Mac OS Quick-Look Plugins
cask 'qlcolorcode'    # QL for code with highlighting
cask 'qlimagesize'    # QL for size info for images
cask 'qlmarkdown'     # QL for markdown files
cask 'qlprettypatch'  # QL for patch / diff files
cask 'qlstephen'      # QL for dev text files
cask 'qlvideo'        # QL for video formats
cask 'quicklook-csv'  # QL for tables in CSV format
cask 'quicklook-json', args: { require_sha: false } # QL for JSON, with trees
cask 'quicklookapk',   args: { require_sha: false } # QL for Android APKs
cask 'webpquicklook',  args: { require_sha: false } # QL for WebP image files

# Mac OS Mods and Imrovments
cask 'alt-tab'        # Much better alt-tab window switcher
cask 'anybar'         # Custom programmatic menubar icons
cask 'copyq'          # Clipboard manager (cross platform)
cask 'espanso'        # Live text expander (cross-platform)
cask 'finicky'        # Website-specific default browser
cask 'hiddenbar'      # Hide / show annoying menubar icons
brew 'iproute2mac'    # MacOS port of netstat and ifconfig
brew 'lporg'          # Backup and restore launchpad layout
brew 'm-cli'          # All in one MacOS management CLI app
cask 'mjolnir'        # Util for loading Lua automations
cask 'openinterminal' # Finder button, opens directory in terminal
cask 'raycast', args: { require_sha: false }  # Spotlight alternative
cask 'santa'          # Binary authorization for security
cask 'shottr'         # Better screenshot utility
brew 'skhd'           # Hotkey daemon for macOS
cask 'stats'          # System resource usage in menubar
brew 'yabai'          # Tiling window manager

# Mac OS Utility Apps
cask 'coteditor'      # Just a simple plain-text editor
cask 'little-snitch'  # Firewall app viewing / blocking traffic
cask 'keka'           # File archiver and extractor
brew 'cirruslabs/cli/tart' # Virtualisation MacOS Apple Silicon

# EOF
