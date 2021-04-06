<p align="center">
  <a href="https://www.paypal.me/krishenriksendk"><img src="https://www.paypalobjects.com/en_GB/i/btn/btn_donate_SM.gif" height="20" /></a>
  <a href="https://www.paypal.me/krishenriksendk" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" height="20" alt="Buy Me A Coffee"></a>
  <a href="https://github.com/krishenriksen/AnberPorts/blob/master/LICENSE.md" target="_blank"><img src="https://camo.githubusercontent.com/78f47a09877ba9d28da1887a93e5c3bc2efb309c1e910eb21135becd2998238a/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4c6963656e73652d4d49542d79656c6c6f772e737667" height="20" alt="MIT License"></a>
  <a>BTC: 31qTzibV73TkvXCnpGyfbk7ntyjq5FtGyi</a>
</p>

## AnberCloud

Synchronize game saves to the cloud for Anbernic devices RG351p/m, RG351v running on ArkOS, The RA and 351elec.

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
- To change key file manually, edit the `key` file located in `/roms/ports/AnberCloud/key`

## Support The Project

[<img src="https://github.com/krishenriksen/AnberPorts/raw/master/sponsor.png" width="200"/>](https://github.com/sponsors/krishenriksen)

[Become a sponsor for AnberPorts](https://github.com/sponsors/krishenriksen)
