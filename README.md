# homebrew legacy versions

Attempt to rebuild previous versions of clients needed for communication with existing older production infrastructure, even after Homebrew has removed them as deprecated upstream.

Switch between Homebrew-installed versions with:
`brew unlink <FORMULA>@<FROM_VERSION>; brew link <FORMULA>@<TO_VERSION>`

## Try This First

Homebrew may have previously included a working version that can still be extracted directly into [your own tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap). You can typically use this version as-is.

`brew extract --version=<VERSION> <FORMULA> <YOUR_GITHUB_USER>/<YOUR_TAP_REPOSITORY_NAME>`

Example:
```
brew extract --version=1.26 kubernetes-cli <YOUR_GITHUB_USER>/<YOUR_TAP_REPOSITORY_NAME>
>>> ==> Searching repository history
>>> ==> Writing formula for kubernetes-cli from revision NNNNNNN to:
>>> /opt/homebrew/Library/Taps/<YOUR_GITHUB_USER>/<YOUR_TAP_REPOSITORY_NAME>/Formula/kubernetes-cli@1.26.rb
```
Then
`brew install kubernetes-cli@1.26`

For more, see: [Homebrew versions documentation](https://docs.brew.sh/Versions)

If it is not possible to extract a working version, see below for using, and for making, similar formulae.

## Alternatives to Homebrew versions

### MacPorts on macOS

You can also use [MacPorts](https://www.macports.org/) instead of brew for this, if you're running on macOS and MacPorts has the software you need.

Example: `sudo port install kubectl-1.27`

When [MacPorts](https://www.macports.org/) has multiple versions and the maintainer has set up a selector, switch between them with `port select …`.

Example:
```
port select --summary | grep kubectl
>>> kubectl     kubectl1.26    kubectl1.23 kubectl1.24 kubectl1.25 kubectl1.26 kubectl1.27 none
sudo port select kubcctl kubectl1.27
>>> Selecting 'kubectl1.27' for 'kubectl' succeeded. 'kubectl1.27' is now active.
```

## How do I install these Homebrew formulae?
`brew install rdump/versions/<formula>`

Or `brew tap rdump/versions` and then `brew install <formula>`.

Example: `brew install rdump/versions/kubernetes-cli@1.24.4`

## How do I make similar Homebrew formulae?
If Homebrew no longer has a version that can be extracted (see above), you can pull the bottle update commit info and make a formula for the old version.

Information for most of these formulae is derived using [Homebrew/core logs](https://github.com/Homebrew/homebrew-core.git) to get the bottle update commit ID for the various versions.  The formulae are then copied to versioned files in the repo, and edited to have a unique `class`, lists of requirements, &c.

Example: The kubectl (kubernetes-cli) bottle update commit ID, for the version you want to keep around for rebuilding, can most easily be pulled from your local homebrew-core clone's log.
```
cd ~/src/github.com/Homebrew/homebrew-core && git checkout master && git pull && \
git --no-pager log --oneline  master -- Formula/kubernetes-cli.rb | grep "update 1\.24.* bottle"
>>> d55b2975852 kubernetes-cli: update 1.24.4 bottle.
…
```

That bottle update commit ID can be used to `git checkout d55b2975852` (into detached HEAD state) for seeing your version-current formula of interest with `bbedit Formula/kubernetes-cli.rb` (or use another editor of your choice, but [BBEdit doesn't suck®](https://barebones.com/bbedit))

Copy that formula or necessary parts to your intended formula file in your versions repo, update `class` name appropriately, and build locally.

In some cases (increasingly as the version ages), you'll need to debug problems related to golang version requirements and the like.

## Documentation
For more docs, check `brew help`, look at `man brew`, or check [Homebrew's documentation site](https://docs.brew.sh).

