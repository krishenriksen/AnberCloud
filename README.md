# AnberCloud

Synchronize game saves to the cloud for Anbernic devices RG351p/m, RG351v running on ArkOS, The RA and 351elec.

- [AnberPorts required to install and run](https://github.com/sponsors/krishenriksen)

## What It Actually Does

Assuming that everything is configured, it will do the following:

- Game saves and game states directories will be uploaded to github when you sync, protected by a uniquiely generated key file.

- If you want to sync to another device, link this to your main `device id` in the menu, and change the key file to match the generated one on your main device.

- When you end or start a game current saves and states will be downloaded and synced with the newest versions.

- If you want to revert to an old save, you can look it up in the commit and replace with this.

- When you save a game or game state, it is uploaded to github under your unique identifier.

## Protecting Your Save Games Since 2021

You can generate a new unique key file in AnberCloud, by selecting Key and clicking the A button. This will password protect new game saves with this key file.

- Note that you will not be able to restore old game saves and states unless you've written down and saved the key file used for these.
- To change key file manually, edit the `key` file located in `/roms/ports/key`

Support the project
---

[![Donate](https://github.com/krishenriksen/AnberPorts/raw/master/donate.png)](https://www.paypal.me/krishenriksendk)
[![Patreon](https://github.com/krishenriksen/AnberPorts/raw/master/patreon.png)](https://www.patreon.com/bePatron?u=54003740)
[![Sponsor](https://github.com/krishenriksen/AnberPorts/raw/master/sponsor.png)](https://github.com/sponsors/krishenriksen)
