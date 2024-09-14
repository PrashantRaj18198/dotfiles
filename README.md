## Dotfiles


## Setup dotfiles

```console
cd ~
git clone https://github.com/PrashantRaj18198/dotfiles.git dotfiles
```

### Setup auto_sync to push to upstream when any of the dotfiles have changed

```console
cp dotfiles/daemons/com.prashant.dotfiles_auto_sync.plist ~/Library/LaunchAgents/com.prashant.dotfiles_auto_sync.plist
```
