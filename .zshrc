# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
# Export wlsu browser view
export BROWSER=wslview
# Set theme
# Set config home
export XDG_CONFIG_HOME="$HOME/.config"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Set personal aliases
alias h3='vcmiclient'

# Set up alias for devcontainres
alias dcb='devcontainer build --workspace-folder .'
alias dcu='devcontainer up --workspace-folder .'
alias dce='devcontainer exec --workspace-folder . zsh'

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Don't put duplicate lines or lines starting with space in the history.
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Set history file size
HISTSIZE=1000
SAVEHIST=0

# Share history between all sessions
setopt SHARE_HISTORY

# Allow terminal to get updated window dimensions following a resize
TRAPWINCH() {
  [[ "$CURRENT_EUID" -eq 0 ]] && return  # Ignore if running as root
  emulate -L zsh
  local size=$(stty size 2>/dev/null)
  LINES=${size%% *}
  COLUMNS=${size##* }
}

# Enable ** to match all files and directories recursively
setopt GLOBSTARSHORT

# Enable colour support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ls='ls -G'
    alias grep='grep --colour=auto'
    alias fgrep='fgrep --colour=auto'
    alias egrep='egrep --colour=auto'
fi

use_gh_template() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: git_clone_template <user/repo>"
        return 1
    fi

    local temp_dir=$(mktemp -d)
    trap 'rm -rf "$temp_dir"' EXIT INT
    local repo="https://github.com/conig/$1.git"
    git clone --quiet $repo $temp_dir

    if [ $? -ne 0 ]; then
        echo "Failed to clone repository."
        return 1
    fi

    rsync -av --exclude='.git' -u $temp_dir/ .
    echo "Repository contents copied to $(pwd)"
}

export PATH="$HOME/.local/bin:$PATH"

alias r='radian --silent'
alias R='R --no-save --no-restore --silent'
alias py='python3'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

cd_win() {
    local win_path="$1"
    local wsl_path

    # Convert drive letter to lowercase and replace ':' with '/mnt/'
    wsl_path=$(echo "$win_path" | sed 's|\\|/|g' | sed 's|^\([a-zA-Z]\):|/mnt/\L\1|')

    if [[ -d "$wsl_path" ]]; then
        cd "$wsl_path" || return
    else
        echo "Directory not found: $wsl_path"
    fi
}

install_r() {
  local ver=$1

  curl -O https://cdn.rstudio.com/r/ubuntu-2404/pkgs/r-${ver}_1_amd64.deb

  if [ $? -ne 0 ]; then
    echo "Failed to download R version ${ver}"
    return 1
  fi

  sudo gdebi -n r-${ver}_1_amd64.deb

  if [ $? -ne 0 ]; then
    echo "Failed to install R version ${ver}"
    return 1
  fi

  /opt/R/${ver}/bin/R --version

  if [ $? -ne 0 ]; then
    echo "Failed to verify R version ${ver}"
    return 1
  fi

  sudo ln -sf /opt/R/${ver}/bin/R /usr/local/bin/R
  sudo ln -sf /opt/R/${ver}/bin/Rscript /usr/local/bin/Rscript

  rm -f r-${ver}_1_amd64.deb

  echo "R version ${ver} installed successfully"
}

latest_r() {

 curl -s https://cran.r-project.org/bin/windows/base/ | grep -oP '(?<=<title>)[^<]+' | grep -oP '[0-9]+\.[0-9]+\.[0-9]+'

}

current_r(){

local current
current=$(Rscript -e "with(R.version, cat(paste0(major, '.', minor)))")
echo $current
}

check_r_update() {
    local current
    current=$(Rscript -e "with(R.version, cat(paste0(major, '.', minor)))")

    local latest
    latest=$(latest_r)

    if [ "$current" != "$latest" ]; then
        echo "R version $current is outdated. Latest is $latest"
        return 1
    fi

}

r_ver() {

  local currentVer
  local latestVer

  currentVer=$(current_r)
  latestVer=$(latest_r)
  echo "R (current): $currentVer"
  echo "R (remote): $latestVer"
 
 # If current version is not the latest
  # call install_r with the latest version
  
  if [ "$currentVer" != "$latestVer" ]; then
    # tell user

    echo "R version $currentVer is outdated. Latest is $latestVer"
    echo "Do you want to update R? (y/n)"
    read -r response

    if [ "$response" != "y" ]; then
      return 1
    fi
    install_r $latestVer
  fi

}

#dotfiles function that prevents add . 

dotfiles() {
    # Check if the command is 'add' and the argument is '.'
    if [[ "$1" == "add" && "$2" == "." ]]; then
        echo "❌ Error: 'dotfiles add .' is disabled to prevent adding all files to the dotfiles repository."
        echo "    Please specify files or directories explicitly."
        return 1
    fi

    # Execute the git command with the provided arguments
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

alias t='tmux'

export EDITOR='nvim'
export VISUAL='nvim'


# Create backup script
backup_packages() {
    # Create a directory for the backup if it doesn't already exist
    BACKUP_DIR="$HOME/.system_backups"
    mkdir -p "$BACKUP_DIR"

    # Backup installed packages
    dpkg --get-selections > "$BACKUP_DIR/package-selections.txt"
    echo "Package selections saved to $BACKUP_DIR/package-selections.txt"

    # Backup list of manually installed packages
    apt-mark showmanual > "$BACKUP_DIR/manual-packages.txt"
    echo "List of manually installed packages saved to $BACKUP_DIR/manual-packages.txt"

    # Backup repository list
    cp -R /etc/apt/sources.list* "$BACKUP_DIR/"
    cp -R /etc/apt/sources.list.d "$BACKUP_DIR/"
    echo "APT repository list saved to $BACKUP_DIR"

    # Generate restore.sh script
    cat <<'EOF' > "$BACKUP_DIR/restore.sh"
#!/bin/bash

# Define backup directory
BACKUP_DIR="$HOME/.system_backups"

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo."
    exit 1
fi

# Restore APT repository list
sudo cp -R "$BACKUP_DIR/sources.list*" /etc/apt/
sudo cp -R "$BACKUP_DIR/sources.list.d" /etc/apt/
echo "APT repository list restored."

# Update package lists
sudo apt-get update

# Restore package selections
sudo dpkg --set-selections < "$BACKUP_DIR/package-selections.txt"
sudo apt-get dselect-upgrade -y
echo "Packages restored."

# Install manually installed packages
xargs -a "$BACKUP_DIR/manual-packages.txt" -r sudo apt-get install -y
echo "Manually installed packages restored."

# Fix broken dependencies
sudo apt-get install -f -y

echo "Restore completed!"
EOF

    # Make the restore script executable
    chmod +x "$BACKUP_DIR/restore.sh"
    echo "Restore script saved to $BACKUP_DIR/restore.sh and made executable."

    echo "Backup completed!"

    # Verification
    if [ -s "$BACKUP_DIR/package-selections.txt" ] && [ -s "$BACKUP_DIR/manual-packages.txt" ]; then
        echo "Backup verified: Files are non-empty."
    else
        echo "Warning: One or more backup files are empty."
    fi

    # Output logging
    LOG_FILE="$BACKUP_DIR/backup.log"
    {
        echo "Backup completed on $(date)"
        echo "Package selections and manually installed packages saved."
        echo "APT repository list saved."
        echo "Restore script generated and made executable."
    } >> "$LOG_FILE"
    echo "Backup process logged to $LOG_FILE"
}

# Create repo-to-txt fn
function clip_repo() {
    # Create a temporary directory
    tempdir=$(mktemp -d)

    # Run repo-to-text and output to the temporary directory
    repo-to-text --output-dir "$tempdir" "$@"

    # Find the generated .txt file
    txtfile=$(find "$tempdir" -name '*.txt' -print -quit)

    if [[ -f "$txtfile" ]]; then
        # Copy the contents of the .txt file to the clipboard
        cat "$txtfile" | pbcopy

        # Optionally, notify the user
        echo "Repository text has been copied to the clipboard."
    else
        echo "No .txt file found in the temporary directory."
    fi

    # Delete the temporary directory
    rm -rf "$tempdir"
}


# Set default editor
export EDITOR=nvim

# Load API keys
# export ANTHROPIC_API_KEY=$(cat ~/.keys/claude.txt)

# Check if we are in a tmux session, and if not, start tmux
if [ -z "$TMUX" ] && [ -n "$TERM" ] && [ "$TERM" != "linux" ]; then
    # Kill existing 'home' session if it exists
    if tmux has-session -t="home" 2> /dev/null; then
        tmux kill-session -t "home"
    fi

    # Start a new 'home' session
    tmux new-session -ds "home" -c "$HOME"

    # Attach to the 'home' session
    tmux attach-session -t "home"
fi

# Function to select or create a tmux session based on a directory
tmux_switch_or_cd() {
    # Function to switch tmux sessions or navigate directories based on context

    # Determine the selected directory
    if [[ $# -eq 1 ]]; then
        selected="$1"
    else
        # Paths to the external configuration files
        static_dirs_file=~/.project_static_dirs
        dynamic_dirs_file=~/.project_dynamic_dirs

        # Arrays to hold static and dynamic directories
        static_dirs=()
        dynamic_dirs=()

        # Function to strip surrounding quotes
        strip_quotes() {
            local str="$1"
            # Remove leading and trailing double quotes
            str="${str%\"}"
            str="${str#\"}"
            # Remove leading and trailing single quotes
            str="${str%\'}"
            str="${str#\'}"
            echo "$str"
        }

        # Read the static directories file if it exists
        if [[ -f "$static_dirs_file" ]]; then
            while IFS= read -r line; do
                # Strip quotes and skip comments and empty lines
                [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
                line=$(strip_quotes "$line")
                static_dirs+=("$line")
            done < "$static_dirs_file"
        else
            # Default static directories if the file does not exist
            static_dirs=(~ ~/.config/nvim ~/repos)
        fi

        # Read the dynamic directories file if it exists
        if [[ -f "$dynamic_dirs_file" ]]; then
            while IFS= read -r line; do
                # Strip quotes and skip comments and empty lines
                [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
                line=$(strip_quotes "$line")
                dynamic_dirs+=("$line")
            done < "$dynamic_dirs_file"
        else
            # Default dynamic directories if the file does not exist
            dynamic_dirs=(~/)
        fi

        selected=$( (
            # Print static directories first
            printf "%s\n" "${static_dirs[@]}"

            # Add dynamic directories using find, with explicit path expansion
            for dir in "${dynamic_dirs[@]}"; do
                # Expand ~ to $HOME
                expanded_dir="${dir/#\~/$HOME}"
                # Check if the directory exists before running find
                if [[ -d "$expanded_dir" ]]; then
                    find "$expanded_dir" -mindepth 1 -maxdepth 1 -type d ! -path "$HOME/.config" -print
                else
                    echo "Warning: Directory '$expanded_dir' does not exist." >&2
                fi
            done
        ) | fzf --pointer='▶')

        # Exit if no selection was made
        if [[ -z "$selected" ]]; then
            return 0
        fi
    fi

    # Expand ~ to $HOME in selected path
    expanded_selected="${selected/#\~/$HOME}"

    # Extract the basename of the selected directory to use as session name
    session_name=$(basename "$expanded_selected")
    session_name="${session_name// /_}"   # Convert spaces to underscores
    # Replace periods with underscores in the session name
    session_name="${session_name//./_}"

    # If inside tmux, switch sessions or create a new one
    if [[ -n "$TMUX" ]]; then
        # Use the '=' prefix to specify the session name exactly
        if tmux has-session -t "=$session_name" 2>/dev/null; then
            # Switch to the existing session
            tmux switch-client -t "=$session_name"
        else
            # Create a new session with the selected directory as the starting directory
            tmux new-session -s "$session_name" -c "$expanded_selected" -d
            # Switch to the new session
            tmux switch-client -t "=$session_name"
        fi
    else
        # If not inside tmux, simply change to the selected directory
        cd "$expanded_selected" || {
            echo "Error: Directory '$expanded_selected' does not exist or cannot be accessed." >&2
            return 1
        }
    fi
}
# Bind Ctrl-p to the tmux-switch function
# Create the Zsh widget
zle -N tmux-switch-widget tmux_switch_or_cd

# Bind Ctrl-\ to the tmux-switch-widget
bindkey 'jj' tmux-switch-widget

start_nvim() {
# start neovim with nvim
 nvim
}
# start_nvim widget
zle -N start_nvim
# bind to ctrl-n
bindkey 'fj' start_nvim

alias we="explorer.exe ."

# Fuzzy find directories up to 6 levels deep
fuzzy_find_dir() {
    local selected_dir

    # Use find to list directories up to 6 levels deep and pass to fzf
    selected_dir=$(find . -type d -maxdepth 6 2>/dev/null | fzf --pointer='▶' --preview 'ls -la {}')

    if [[ -n "$selected_dir" ]]; then
        # Change directory to the selected directory
        cd "$selected_dir" || return
    fi
}

# Optional: Create a Zsh widget for binding to a key
zle -N fuzzy_find_dir_widget fuzzy_find_dir

# Bind the widget to a key combination (e.g., Ctrl-D)
bindkey '^f' fuzzy_find_dir_widget
# Install nvim function

install_neovim() {
    local version=$1
    local url="https://github.com/neovim/neovim/releases/download/${version}/nvim-linux64.tar.gz"
    local tmp_dir=$(mktemp -d)

    # Download and install Neovim
    echo "Downloading Neovim version ${version}..."
    curl -Lo "${tmp_dir}/nvim-linux64.tar.gz" "${url}"
    
    if [[ $? -ne 0 ]]; then
        echo "Failed to download Neovim. Please check the version number."
        return 1
    fi
    
    echo "Extracting Neovim..."
    tar -xzvf "${tmp_dir}/nvim-linux64.tar.gz" -C "${tmp_dir}"
    
    echo "Installing Neovim..."
    sudo cp -r "${tmp_dir}/nvim-linux64/"* /usr/local/

    # Clean up
    echo "Cleaning up..."
    rm -rf "${tmp_dir}"

    echo "Neovim version ${version} installed successfully."
}

vaultpush() {
    # Define the vault directory
    local vault_dir="$HOME/.vaults"

    # Stage all changes in the specified directory
    git -C "$vault_dir" add .

    # Get the current date and time
    local current_time
    current_time=$(date '+%Y-%m-%d %H:%M:%S')

    # Commit with a message including the current time
    git -C "$vault_dir" commit -m "update obsidian $current_time"

    # Push the changes to the remote repository
    git -C "$vault_dir" push
}

alias wmclass="xprop | grep WM_CLASS"

