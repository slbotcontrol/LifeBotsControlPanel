// LifeBots Control Panel script for listening to a channel and sending messages to the bot
// Control Panel documentation: https://slbotcontrol.github.io/control_panel/
//
// Customize the bot name, access code, channel, and debug
//
//////// CUSTOMIZE THESE: BOT NAME, BOT CODE, CHANNEL, AND DEBUG //
string botName = "Bot Name";                                     // REQUIRED
string botCode = "Bot Access Code";                              // REQUIRED
// The channel number to listen on and relay                     //
integer LISTEN_CHANNEL = -7742001;                               // OPTIONAL
// Set DEBUG to 1 to enable debug output                         //
integer DEBUG = 0;                                               // OPTIONAL
//////// END CUSTOMIZE, NO CHANGES BEYOND HERE ////////////////////

string deviceName = "Channel Relay";

//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer BOT_LISTEN_IM               = 280126;   //
integer BOT_EVENT_LISTEN_IM         = 280205;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_SETUP_DEBUG             = 280105;   //
integer BOT_SETUP_DEBUG_SUCCESS     = 280107;   //
integer BOT_SETUP_RETRY             = 300002;   //
//////////////////////////////////////////////////

// Number of retries waiting for Control Panel to initialize
integer retries = 0;

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
            retries = 0;

            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "1", "");
            } else {
                // Request listen to IMs
                llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
            }
        } else if (num==BOT_SETUP_RETRY) {
            if (retries > 12) {
                llOwnerSay("Unable to setup bot");
                retries = 0;
            } else {
                llOwnerSay("LifeBots Control Panel is not yet initialized, trying again in 5 seconds...");
                retries++;
                llSleep(5.0);
                llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
            }
        } else if (num == BOT_SETUP_FAILED) {
            retries = 0;
            // We split the string parameter to the lines
            list parts=llParseString2List(str,["\n"],[]);

            // The first line is a status code, and second line is the bot expiration date
            string code=llList2String(parts,0);
            string expires=llList2String(parts,1);
            
            // Setup failed somehow
            llOwnerSay("Bot setup failed:\n"+
              "error code: "+code+"\n"+
              "expired: "+expires);
        } else if (num==BOT_EVENT_LISTEN_SUCCESS) {
            // We are ready!
            llOwnerSay("Channel Relay Ready!");
        } else if (num==BOT_SETUP_DEBUG_SUCCESS) {
            // Request listen to IMs if debug enabled
            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
            }
        } else if (num == BOT_EVENT_LISTEN_IM) {
            // This event is received when the bot hears a message in IM
            // The 'str' contains the message details
            llOwnerSay("Bot heard a message: " + str);

            // After the first IM turn off debugging
            if (DEBUG == 1) {
                DEBUG = 0;
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "0", "");
            }
            
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
