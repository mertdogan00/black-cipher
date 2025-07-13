
# 🛡️ BlackCipher

**BlackCipher** is a sleek, terminal-native encryption utility that compresses and encrypts files or folders into `.tar.zst.gpg` format using GPG (AES256).  
Designed for developers, sysadmins, and privacy-focused users who want complete control from the command line — with no GUI prompts or bloat.

---

## 📜 Description

BlackCipher enables you to:

- 🔐 Encrypt files/folders using GPG AES256 (symmetric)
- 📦 Compress data to `.tar.zst` with `zstd`
- 🧊 Output fully encrypted archives as `.tar.zst.gpg`
- 🔓 Decrypt, decompress, and extract — fully from the terminal
- 🧹 Silently purge GPG memory cache after operations

---

## ⚙️ How It Works

1. Choose: encrypt or decrypt
2. Enter the full path to a file/folder
3. Encryption flow:
   - `.tar` archive
   - `.zst` compression
   - `gpg --symmetric` encryption (AES256)
4. Decryption flow:
   - GPG decrypt
   - zstd decompress
   - tar extract
5. GPG agent memory is auto-cleared

---

## ▶️ Usage

```bash
chmod +x black-cipher.sh
./black-cipher.sh
```

---

## 💡 Requirements

- `bash`
- `gpg`
- `zstd` (unzstd included)
- `tar`

---

## 🧼 GPG Agent Behavior

- `--pinentry-mode loopback` forces terminal-only password entry
- GUI pinentry is disabled completely
- Cache is cleared silently after encryption/decryption

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).  
© 2025 – Feel free to use, modify, and distribute.


