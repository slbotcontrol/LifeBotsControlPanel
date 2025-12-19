# LifeBots Control Panel Release Notes

**[Note:]** This is the initial release of `LifeBots Control Panel`. The system is still under development and subsequent releases will follow quickly. Consider this release an `Alpha` release intended for internal testing only.

`LifeBots Control Panel` is an LSL script library to control `LifeBots` bots from an LSL script.

The `LifeBots Control Panel` is a scripted in-world object that acts as a bridge between your `LifeBots` management scripts and your `LifeBots` bots. The control panel communicates with your bots using the `LifeBots API` and an HTTP server listening to events.

## Deployment

Download the `LifeBotsControlPanel.lsl` script and `Configuration` notecard.

In Second Life create a new script named `LifeBotsControlPanel` and copy the contents of `LifeBotsControlPanel.lsl` into this new script. Similarly, create a new notecard named `Configuration` and copy the contents of `Configuration` into this new notecard.

Edit the `Configuration` notecard and replace `your-api-key` in the line `LB_API_KEY = your-api-key` with your `LifeBots` developer API key.

You do not need to edit the `LifeBotsControlPanel` script.

Create a new object, right click the object and select `Edit`.

Copy the `LifeBotsControlPanel` script and `Configuration` notecard into the `Contents` tab of the new object.

Copy your `LifeBots` command and control script into the `Contents` tab of the new object. If you do not have a command and control script then you can use one of the examples described below.

Close the Edit window.

## LifeBots Command and Control Script Examples

`LifeBots Control Panel` acts as a bridge between your command and control scripts and your `LifeBots` bots. Included in this release are several example command and control scripts. To deploy one of these command and control scripts, first edit the script and configure your `LifeBots` bot name and bot secret. 

Once configured with the bot name and secret, copy the example `LifeBots` command and control script into the `Contents` tab of the `LifeBots Control Panel` object.

**[Note:]** Some example command and control scripts may have additional variables that need to be configured. For example, the `sit_on_payment` example needs to be configured with the UUID of the object you want your bot to sit on when payment is received.
