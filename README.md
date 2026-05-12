# YT Shorts Converter

Convert gameplay videos into high-quality YouTube Shorts automatically using PowerShell + FFmpeg.

Supports:

* 16:9 → 9:16 conversion
* Blur background modes
* Crop modes
* 1:1 support
* 4:3 support
* 60 FPS export
* Trim support
* Easy CLI workflow

---

# Features

✅ 9:16 Center Crop
<img width="1914" height="926" alt="{679A6EDD-4CD5-49D4-97E3-14302933B1D4}" src="https://github.com/user-attachments/assets/2cf838df-168b-453d-85ea-e70997ee99ad" />

✅ 9:16 Blur Background

<img width="579" height="941" alt="{5628591E-BB8A-4C4A-B313-4DE4D7F40239}" src="https://github.com/user-attachments/assets/7c27249e-90e7-4b9d-9d0c-f6bbd5b1ba7d" />

✅ 1:1 Center Crop
<img width="1920" height="938" alt="{8648B77C-7C00-4556-9B3D-8ADE7961EE62}" src="https://github.com/user-attachments/assets/065f8b60-2b90-4d8b-a308-920924a2506e" />

✅ 4:3 Center Crop
<img width="1920" height="935" alt="{E4D4DE73-711E-4005-A376-672C430AE13B}" src="https://github.com/user-attachments/assets/e11f7227-1e8d-4113-856e-fe5f1a13b297" />

✅ 1:1 Blur In 9:16
<img width="1919" height="940" alt="{4B6D4D50-DB77-4B0A-9800-8642F7C09154}" src="https://github.com/user-attachments/assets/9c059ba0-31f8-45a2-985f-2027f8bf512b" />

✅ 4:3 Blur In 9:16
<img width="1920" height="931" alt="{EA3B2C0C-8DCA-4739-A1A1-01268BCED5CB}" src="https://github.com/user-attachments/assets/ae733d53-79f3-4445-95d2-aadf31945026" />

✅ Top Crop + Bottom Full Video
<img width="1918" height="935" alt="{3BA61D41-7DF0-4683-B416-3E0869DA8E84}" src="https://github.com/user-attachments/assets/f7ca96c4-473b-4afa-8fb7-4ead8f0dd3be" />

✅ FFmpeg Auto Support

✅ High Quality H264 Export

✅ Audio Support

✅ Fast Rendering


---

# Core Files

* `converter.ps1`
* `ffmpeg.ps1`
* `modes.ps1`
* `output.ps1`
* `trim.ps1`
* `ui.ps1`
* `videos.ps1`

---

# Requirements

* Windows
* PowerShell 5+
* FFmpeg

---

# Run Directly

Open PowerShell and run:

```powershell id="m4x8qh"
iwr "https://raw.githubusercontent.com/Reggarfgod/YT-Shorts-Converter/refs/heads/main/main.ps1" -UseBasicParsing | iex
```

---

# Example Modes

## 9:16 Crop

Perfect for:

* YouTube Shorts
* TikTok
* Instagram Reels

## Blur Background

Creates cinematic shorts with blurred side background.

## 1:1 Mode

Best for:

* Instagram posts
* Square videos

---

# Output

Converted videos are saved inside:

```text id="k7d2pq"
Converted_Output/
```

---

# Screenshots

<img width="1134" height="647" alt="E8E891E4-6138-4C2A-9355-3AE8ECCBFADD" src="https://github.com/user-attachments/assets/26d58b33-9621-4e29-862c-406fc9a97093" /><img width="1128" height="624" alt="4CF96DE3-8521-4DB6-B688-963752385B29" src="https://github.com/user-attachments/assets/8bfb1fe0-f6d6-4d66-8d2e-e32916790437" />
<img width="1115" height="630" alt="8581718F-9723-43F9-8566-7EA8D23BB226" src="https://github.com/user-attachments/assets/205527dd-3ffd-48f0-8879-b9249c88eb46" />
<img width="1109" height="617" alt="5202BE00-3D78-4BDA-A7E6-820CD126B84D" src="https://github.com/user-attachments/assets/585b0c96-abde-4a8b-8515-284b375805bf" />



---

# License

MIT License

---

# Author

Reggarf
