// Example script that returns a list of the bots outfits
//
// This example illustrates how to parse the JSON body returned by the API request
//
//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer LIST_OUTFITS                = 299006;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_JSON_RESPONSE           = 300000;   //
//////////////////////////////////////////////////

////////////////////////////////////////////////////
// List bot's outfits
////////////////////////////////////////////////////
string deviceName = "Bot Outfits";
string botName = "Bot Name";
string botCode = "Bot Access Code";
key touchUUID = NULL_KEY;
    
default {
    state_entry() {
        // Setup Device
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
        
        // Setup Bot
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
    }
    
    // List bot's outfits on touch
    touch_start(integer num) {
        touchUUID = llDetectedKey(0);
        llMessageLinked(LINK_SET, LIST_OUTFITS, "", "");
    }
    
    // Notify owner if device was successfully initialized
    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if (num == BOT_SETUP_SUCCESS) {
            // Inform user of successful setup
            llOwnerSay(deviceName + " ready!");
        } else if (num == BOT_SETUP_FAILED) {
            // Inform user of failed setup
            llOwnerSay("ERROR: LifeBots Control Panel setup failed for " + deviceName);
        } else if (num == BOT_JSON_RESPONSE) {
            llOwnerSay(botName + " outfits");
        }
    }
}
