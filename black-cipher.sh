#!/bin/bash 

# === Color definitions for pretty terminal output ===
green="\033[1;32m"
red="\033[1;31m"
yellow="\033[1;33m"
reset="\033[0m"

# === Enforce terminal-only GPG usage (no GUI popups) ===
export GPG_TTY=$(tty)
export PINENTRY_USER_DATA="USE_TTY=1"
export GPG_AGENT_INFO=
echo "pinentry-program /usr/bin/pinentry-tty" > ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent > /dev/null 2>&1
gpgconf --launch gpg-agent

echo -e "${green}🔐 GPG-BOX v2 — Terminal Ninja Edition${reset}"
echo -e "${yellow}What would you like to do?${reset}"
echo "1. Compress and encrypt a file/folder with GPG (.tar.zst.gpg)"
echo "2. Decrypt and extract a .gpg archive"
echo "3. Clear GPG memory cache"
echo "4. Exit"

read -p "👉 Enter your choice [1-4]: " choice

# === Option 1: Compress and encrypt ===
if [[ "$choice" == "1" ]]; then
    read -p "📁 Enter full path of file/folder to encrypt: " input
    [[ ! -e "$input" ]] && echo -e "${red}❌ Invalid path.${reset}" && exit 1

    name=$(basename "$input")
    tarfile="${name}.tar"
    zstfile="${tarfile}.zst"
    gpgfile="${zstfile}.gpg"

    echo -e "${green}[+] Archiving: $tarfile...${reset}"
    tar -cf "$tarfile" "$input" || exit 1

    echo -e "${green}[+] Compressing with zstd: $zstfile...${reset}"
    zstd "$tarfile" -o "$zstfile" || exit 1
    rm "$tarfile"

    echo -e "${green}[+] Encrypting with GPG AES256: $gpgfile...${reset}"
    gpg --pinentry-mode loopback --symmetric --cipher-algo AES256 "$zstfile" && rm "$zstfile"

    echo -e "${green}✅ Encrypted archive created: $gpgfile${reset}"

    # Automatically clear GPG memory after encryption
    gpgconf --reload gpg-agent
    gpgconf --kill gpg-agent
    echo -e "${yellow}🧹 GPG memory cache cleared.${reset}"

# === Option 2: Decrypt and extract ===
elif [[ "$choice" == "2" ]]; then
    read -p "🔓 Enter full path to .gpg file: " gpgfile
    [[ ! -f "$gpgfile" ]] && echo -e "${red}❌ File not found.${reset}" && exit 1

    base=$(basename "$gpgfile" .gpg)
    zstfile="$base"
    tarfile="${base%.zst}"
    output_dir="extracted_${tarfile%.tar}"

    echo -e "${green}[+] Decrypting with GPG...${reset}"
    gpg --pinentry-mode loopback --output "$zstfile" --decrypt "$gpgfile" || exit 1

    echo -e "${green}[+] Decompressing (.zst)...${reset}"
    unzstd "$zstfile" || exit 1

    echo -e "${green}[+] Extracting archive (.tar)...${reset}"
    mkdir -p "$output_dir"
    tar -xf "$tarfile" -C "$output_dir" || exit 1
    rm "$tarfile"

    echo -e "${green}✅ Files extracted to: $output_dir${reset}"

    # Automatically clear GPG memory after decryption
    gpgconf --reload gpg-agent
    gpgconf --kill gpg-agent
    echo -e "${yellow}🧹 GPG memory cache cleared.${reset}"

# === Option 3: Clear GPG cache only ===
elif [[ "$choice" == "3" ]]; then
    echo -e "${yellow}[!] Clearing GPG cache...${reset}"
    gpgconf --reload gpg-agent
    gpgconf --kill gpg-agent
    echo -e "${green}✅ GPG memory cleared.${reset}"

# === Option 4: Exit ===
elif [[ "$choice" == "4" ]]; then
    echo -e "${green}👋 See you next mission, ninja!${reset}"
    exit 0

# === Invalid choice ===
else
    echo -e "${red}❌ Invalid option. Please choose 1–4.${reset}"
    exit 1
fi
