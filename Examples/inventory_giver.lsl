// This script asks the bot to give out an inventory object
// to whoever touches the prim the script is in
//
// Sets up the device and the bot in state_entry
// Sends out inventory object on touch
// Note that the inventory object is the UUID of an asset in the Bots inventory.
//
///////// LIFEBOTS COMMAND & CONTROL ////////////////
integer BOT_SETUP_SETBOT            = 280101;      //
integer BOT_SETUP_DEVICENAME        = 280103;      //
integer BOT_GIVE_INVENTORY          = 280150;      //
integer BOT_SETUP_SUCCESS              = 280201;   //
integer BOT_SETUP_FAILED               = 280202;   //
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
// Simple Inventory giver example
/////////////////////////////////////////////////////
string deviceName = "Inventory Giver";
string botName = "Bot Name";
string botCode = "Bot Access Code";
string inventoryID = "UUID goes here";

default {
    state_entry() {
        // Setup Device
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
    }
    
    touch_start(integer num) {
        // Setup Bot
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
    }

    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if(num==BOT_SETUP_SUCCESS) {
            // We added our bot fine
            llOwnerSay("Successfully setup bot: " + str);
            
            // Send inventory item to whoever touched the prim
            llMessageLinked(LINK_SET, BOT_GIVE_INVENTORY, inventoryID, llDetectedKey(0));
        } else if(num==BOT_SETUP_FAILED) {
            // We split the string parameter to the lines
            list parts=llParseString2List(str,["\n"],[]);

            // The first line is a status code, and second line is the bot expiration date
            string code=llList2String(parts,0);
            string expires=llList2String(parts,1);
            
            // Setup failed somehow
            llOwnerSay("Bot setup failed:\n"+
              "error code: "+code+"\n"+
              "expired: "+expires);
        }
    }
    
}
