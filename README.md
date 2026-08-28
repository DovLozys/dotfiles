# dotfiles

`$HOME` is the repo. `.gitignore` is `*`, so files are tracked only via `git add -f`.

## New machine

```sh
ssh-keygen -t ed25519 -C "755086+DovLozys@users.noreply.github.com"
# add ~/.ssh/id_ed25519.pub to GitHub as Authentication Key and Signing Key
cd ~ && git init && git remote add origin git@github.com:DovLozys/dotfiles && git fetch && git checkout -f main
printf '[user]\n\tsigningkey = %s/.ssh/id_ed25519.pub\n' "$HOME" > ~/.config/git/local
```

Machine-specific config lives in untracked files (e.g. `~/.config/git/local`).
