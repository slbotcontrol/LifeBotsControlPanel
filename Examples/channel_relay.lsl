// LifeBots Control Panel script for listening to a channel and sending messages to the bot
// Control Panel documentation: https://slbotcontrol.github.io/control_panel/

//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer BOT_LISTEN_IM               = 280126;   //
integer BOT_EVENT_LISTEN_IM         = 280205;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_RESPONSE                = 300000;   //
//////////////////////////////////////////////////

// Configuration variables (replace with your actual values)
string deviceName = "Channel Relay";
string botName = "Bot Name";
string botCode = "Bot Access Code";
integer LISTEN_CHANNEL = -7742001; // The channel number to listen on and relay

// Global variables
integer listenEnabled = FALSE;
integer listen_handle;
key botKey = NULL_KEY;

default {
    state_entry() {
        llOwnerSay("Starting up LifeBots Control Panel Channel Relay script...");
        // Setup Device and Bot using linked messages
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
        // Request the key from the bot name
        if (botKey == NULL_KEY) {
            botKey = llRequestUserKey(botName);
        }
    }

    dataserver(key queryid, string data)
    {
        if (queryid == botKey) {
            if (data == NULL_KEY) {
                llOwnerSay(botName + " not found or offline.");
            } else {
                llOwnerSay(botName + " ready to receive IMs");
            }
        }
    }

    link_message(integer sender_num, integer num, string str, key id) {
        if (num == BOT_SETUP_SUCCESS) {
            llOwnerSay("Successfully setup bot: " + str + ". Now starting listener.");
            llMessageLinked(LINK_SET, BOT_EVENT_LISTEN_IM, "", "");
            llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
        } else if (num == BOT_SETUP_FAILED) {
            llOwnerSay("Bot setup failed: " + str);
        } else if (num == BOT_LISTEN_IM) {
            llOwnerSay("Received BOT_LISTEN_IM");
        } else if (num == BOT_EVENT_LISTEN_IM) {
            // This event is received when the bot hears a message in IM
            // The 'str' contains the message details
            llOwnerSay("Bot heard a message: " + str);
            
            // Here you can add logic to process the message and decide what to do
            // llMessageLinked(LINK_SET, BOT_COMMAND_SEND_LOCAL_CHAT, "Relaying message: " + str, "");
        }
    }

    touch_start(integer num) {
        if (llDetectedKey(0) == llGetOwner()) {
            if (listenEnabled) {
                llOwnerSay("Touch detected. Removing listen handle from channel " + (string)LISTEN_CHANNEL);
                llListenRemove(listen_handle);
                listenEnabled = FALSE;
            } else {
                llOwnerSay("Touch detected. Send test messages on channel " + (string)LISTEN_CHANNEL);
                listen_handle = llListen(LISTEN_CHANNEL, "", "", "");
                listenEnabled = TRUE;
            }
        }
    }
    
    listen(integer channel, string name, key id, string message) {
        if (channel == LISTEN_CHANNEL) {
            llOwnerSay("Script heard channel message: " + message);
            // Send the message to the LifeBots bot
            if (botKey == NULL_KEY) {
                botKey = llRequestUserKey(botName);
            }
            llInstantMessage(botKey, message);
        }
    }
}
