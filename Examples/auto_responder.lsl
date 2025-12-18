// This script replies to whoever messages the bot with a simple message
//
// In addition, a debug setting is available, illustrating how to enable debug output
//
// Sets up the device and the bot in state_entry
// If the bot was setup successfully listen to IMs
// If we got confirmation that we can listen to IMs now the script is ready
//
///////// LIFEBOTS COMMAND & CONTROL ////////////////
//                                                 //
integer BOT_SETUP_SETBOT            = 280101;      //
// integer BOT_STATUS_QUERY            = 280106;   //
// integer BOT_SETUP_SETOPTIONS        = 280104;   //
integer BOT_SETUP_DEVICENAME        = 280103;      //
integer BOT_SETUP_DEBUG             = 280105;      //
integer BOT_SETUP_DEBUG_SUCCESS     = 280107;      //
integer BOT_INSTANT_MESSAGE         = 280122;      //
integer BOT_LISTEN_IM               = 280126;      //
integer BOT_SETUP_SUCCESS           = 280201;      //
integer BOT_SETUP_FAILED            = 280202;      //
// integer BOT_COMMAND_FAILED          = 280203;   //
integer BOT_EVENT_LISTEN_IM         = 280205;      //
integer BOT_EVENT_LISTEN_SUCCESS    = 280208;      //
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
// Simple AutoResponder example
/////////////////////////////////////////////////////

// Message to send in reply to an IM
string replyMessage = "Hi, got your IM. How's it going?";

// Set DEBUG to 1 to enable debug output
integer DEBUG = 0;

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

            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "1", "");
            } else {
                // Request listen to IMs
                llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
            }
        }
        else if (num==BOT_SETUP_FAILED) {
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
        else if (num==BOT_SETUP_DEBUG_SUCCESS) {
            // Request listen to IMs if debug enabled
            if (DEBUG == 1) {
                llMessageLinked(LINK_SET, BOT_LISTEN_IM, "", "");
            }
        else if (num==BOT_EVENT_LISTEN_SUCCESS) {
            // We are ready!
            llOwnerSay("Auto Responder Ready!");
        }
        else if (num==BOT_EVENT_LISTEN_IM) {
            // Got an IM, auto reply to it
            // Here we could send another linked message requesting the sender
            // Avatar name from UUID and include that in the reply. But we don't.
            llMessageLinked(LINK_SET, BOT_INSTANT_MESSAGE, replyMessage, id);
            // After the first exchange of IMs turn off debugging
            if (DEBUG == 1) {
                DEBUG = 0;
                llMessageLinked(LINK_SET, BOT_SETUP_DEBUG, "0", "");
            }
        }
    }
}
