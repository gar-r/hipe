# WoW Addon Release Steps

## 1. Update Interface version

Edit the `.toc` file and append the new API version to the `## Interface:` line.

## 2. Bump version

Edit the `.toc` file and increment the patch number in the `## Version:` line.

## 3. Check for breaking API changes

Review the patch notes for the new API version:
https://warcraft.wiki.gg/wiki/Patch_<VERSION>/API_changes

Search the addon source for any removed or renamed APIs.

## 4. Commit

```sh
git add -A && git commit -m "update to <API_VERSION>"
git push
```

## 5. Tag

```sh
git tag v<VERSION>
git push origin v<VERSION>
```

## 6. Create release

```sh
gh release create v<VERSION> --repo <REPO> --title "v<VERSION>" --generate-notes
```
