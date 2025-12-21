// This script accepts inventory objects given to the bot
//
///////// LIFEBOTS COMMAND & CONTROL ////////////////
integer BOT_SETUP_SETBOT               = 280101;   //
integer BOT_SETUP_DEVICENAME           = 280103;   //
integer BOT_SETUP_SUCCESS              = 280201;   //
integer BOT_SETUP_FAILED               = 280202;   //
integer BOT_LISTEN_INVENTORY_OFFER     = 280141;   //
integer BOT_EVENT_LISTEN_INVENTORY     = 280206;   //
integer INVENTORY_OFFER_ACCEPT         = 299999;   //
integer BOT_SETUP_DEBUG                = 280105;   //
integer BOT_SETUP_DEBUG_SUCCESS        = 280107;   //
integer BOT_SETUP_RETRY                = 300002;   //
integer BOT_EVENT_LISTEN_SUCCESS       = 280208;   //
integer BOT_INSTANT_MESSAGE            = 280122;   //
/////////////////////////////////////////////////////
                                                   //
// Set DEBUG to 1 to enable debug output
integer DEBUG = 0;

// Number of retries waiting for Control Panel to initialize
integer retries = 0;

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
// Simple Inventory giver example
/////////////////////////////////////////////////////
string deviceName = "Accept Inventory Offers";
string botName = "Bot Name";
string botCode = "Bot Access Code";

default {
    state_entry() {
        // Setup Device
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
        // Setup Bot
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
    }
    
    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if (num==BOT_SETUP_SUCCESS) {
            // Inform user
            llOwnerSay("Successfully setup bot: " + str);
            retries = 0;

            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "1", "");
            } else {
                // Command bot to listen for inventory offers
                llMessageLinked(LINK_SET, BOT_LISTEN_INVENTORY_OFFER, "", "");
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
        } else if(num==BOT_SETUP_FAILED) {
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
            llOwnerSay("Accept Inventory Offers Ready!");
        } else if (num==BOT_SETUP_DEBUG_SUCCESS) {
            // Command bot to listen for inventory offers
            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_LISTEN_INVENTORY_OFFER, "", "");
            }
        } else if (num==BOT_EVENT_LISTEN_INVENTORY) {
            // Split details with a semi colon ";"
            // TODO: figure out what the args are and in what order
            // Remove this line after debugging
            llOwnerSay("BOT_EVENT_LISTEN_INVENTORY str = " + str);
            list details = llParseString2List(str, [";"], []);
    	      string offer_type = llList2String(details,0);
    	      string obj_uuid = llList2String(details,1);
    	      string sender_uuid = llList2String(details,2);
            llMessageLinked(LINK_SET, INVENTORY_OFFER_ACCEPT, offer_type + ";" + obj_uuid + ";" + sender_uuid, id);
            // After the first inventory offer turn off debugging
            if (DEBUG == 1) {
                DEBUG = 0;
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "0", "");
            }
        }
    }
    
}
