// Sit on Object when Payment received
//
// Sets up the device and the bot in state_entry
// If the bot was setup successfully listen to payments
// Whenever we get a payment check if its the correct amount and sit on object if it is
//
///////// LIFEBOTS COMMAND & CONTROL ////////////////
integer BOT_SETUP_SETBOT            = 280101;      //
integer BOT_SETUP_DEVICENAME        = 280103;      //
integer BOT_SETUP_DEBUG             = 280105;      //
integer BOT_SETUP_DEBUG_SUCCESS     = 280107;      //
integer BOT_SETUP_SUCCESS           = 280201;      //
integer BOT_SETUP_FAILED            = 280202;      //
integer BOT_SETUP_RETRY             = 300002;      //
integer BOT_EVENT_LISTEN_SUCCESS    = 280208;      //
// integer BOT_EVENT_LISTEN_MONEY      = 280207;      //
integer BOT_INSTANT_MESSAGE         = 280122;      //
// integer BOT_LISTEN_MONEY_PAYMENTS   = 280142;      //
integer BOT_SIT                     = 290214;      //
integer BOT_LISTEN_DIALOG           = 280143;      //
integer BOT_DIALOG_REPLY            = 280154;      //
integer BOT_EVENT_LISTEN_DIALOG     = 280212;      //
// integer BOT_GIVE_MONEY              = 280151;   //
// integer BOT_GIVE_MONEY_OBJECT       = 290225;   //
// integer BOT_GET_BALANCE             = 280152;   //
// integer BOT_GET_BALANCE_REPLY       = 280211;   //
/////////////////////////////////////////////////////
                                                   //
// Set DEBUG to 1 to enable debug output
integer DEBUG = 0;

// Number of retries waiting for Control Panel to initialize
integer retries = 0;
////////////////////////////////////////////////////
// Sit on object and reply to dialog
////////////////////////////////////////////////////
string deviceName = "Dialog Reply";
string botName = "Bot Name";
string botCode = "Bot Access Code";
// Replace this UUID with that of the sit object
string sitObjectUUID = "fb2d9b84-868d-db30-d487-43228009b4ae";

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
                // Request listen to dialog menus
                llMessageLinked(LINK_SET, BOT_LISTEN_DIALOG, "", "");
                llSleep(5.0);
                llMessageLinked(LINK_SET, BOT_SIT, "", (key)sitObjectUUID);
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
        } else if (num==BOT_SETUP_FAILED) {
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
            llOwnerSay("Dialog Reply Ready!");
        } else if (num==BOT_SETUP_DEBUG_SUCCESS) {
            // Request listen to dialogs if debug enabled
            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_LISTEN_DIALOG, "", "");
                llSleep(5.0);
                llMessageLinked(LINK_SET, BOT_SIT, "", (key)sitObjectUUID);
            }
        } else if (num==BOT_EVENT_LISTEN_DIALOG) {
            llOwnerSay("str = " + str);
            llOwnerSay("id = " + (string)id);
            // Turn off debugging
            if (DEBUG == 1) {
                DEBUG = 0;
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "0", "");
            }
        }
     }
}
