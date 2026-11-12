# ComicFire Blog

Independent Markdown blog for https://blog.comicfire.com, using `jekyll-theme-minimal`.
Local setup only: GitHub Pages and DNS have not been activated by this setup.

The theme configuration, layouts and desktop CSS originate from
[Mithun's personal blog](https://github.com/mithunshanbhag/mithunshanbhag.github.io/tree/f0d17f72d91d0f26060010da2e53fbb825aca7ba).
The copied code retains its MIT license notice. Personal content and tracking configuration are not included.

## Install and preview

Use Ruby and Bundler, either natively or in the existing Ubuntu WSL distribution.
On Ubuntu, native gem compilation also requires `build-essential`, `ruby-dev`,
`libssl-dev` and `libffi-dev` (install missing prerequisites with `sudo apt-get install`).
Run these commands from this repository in PowerShell:

```powershell
# Ubuntu WSL
wsl -d Ubuntu -- bash -lc 'bundle config set --local path "$HOME/.cache/comicfire-blog/bundle"'
wsl -d Ubuntu -- bundle install

# Or, with native Ruby and Bundler
bundle config set --local path vendor/bundle
bundle install

./run-local.ps1
./run-local.ps1 -Drafts
./run-local.ps1 -Drafts -Port 4001
```

Open http://localhost:4000 (or the selected port). The script prefers native Ruby/Bundler,
then Ubuntu WSL. Stop the foreground preview with Ctrl+C. Drafts are opt-in.
WSL gems use the Linux home cache to avoid Windows-mounted filesystem permissions and
native compilation issues. Native Windows gems use the ignored `vendor/bundle` directory.
Local Bundler configuration and generated output are ignored by Git. The lockfile records
locally validated dependencies; GitHub's built-in Pages builder manages its own supported versions.

## Write posts

Create `_posts/YYYY-MM-DD-your-title.md` with front matter:

```yaml
---
layout: post
title: "Your article title"
description: "A short summary for readers and search results."
---
```

Write Markdown below the front matter. Posts use Jekyll's default dated URLs.
Start an unpublished article in `_drafts/`; use `markdown-example.md` as a guide.
To publish later, move the finished draft to `_posts/` with its publication date.
Draft files in this public repository are publicly readable even when excluded from the site.

`unlisted: true` removes a post from the homepage only; it is not private and may still
appear in the feed or sitemap. Comments and analytics are disabled.

Store images and other assets here, for example under `images/`, and reference them
with `{{ '/images/example.png' | relative_url }}` in Markdown. The sidebar logo is an
intentional exception: it loads the hosted 256×256 WebP/PNG picturemark (icon only)
from `assets.comicfire.com`, configured in `_config.yml`. Other article assets remain
in this repository; the blog has no dependency on the application's deployment workflow.

## Build and check

```powershell
wsl -d Ubuntu -- bundle exec jekyll build
```

For native Ruby omit `wsl -d Ubuntu --`. Check `_site/index.html` for the empty state,
and `_site/feed.xml` and `_site/sitemap.xml` for the production hostname. A normal build
must exclude the draft and this README. Use the draft preview to review article formatting
at desktop and mobile widths. Production URL generation uses `https://blog.comicfire.com`;
Jekyll serve uses its local preview address.

## Publish later (separate action)

1. Commit and push the site to `main` when ready.
2. In GitHub Settings → Pages, select **Deploy from a branch**, `main`, `/ (root)`.
3. Configure the custom domain as `blog.comicfire.com` before changing DNS.
4. In Azure DNS add `blog` CNAME → `mithunshanbhag.github.io` (no repository path).
5. Enable Enforce HTTPS after certificate provisioning; verify the homepage, an article,
   feed, sitemap and redirects. GitHub also recommends verifying domain ownership.

The `CNAME` file is prepared already. This is a project Pages repository despite its
`.github.io` name; the personal user Pages site remains separate. See
[GitHub's custom-domain guide](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site).
No Azure hosting resource or Front Door is required.
