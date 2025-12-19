// Sit on Object when Payment received
//
// Sets up the device and the bot in state_entry
// If the bot was setup successfully listen to payments
// Whenever we get a payment check if its the correct amount and sit on object if it is
//
///////// LIFEBOTS COMMAND & CONTROL ////////////////
integer BOT_SETUP_SETBOT            = 280101;      //
// integer BOT_STATUS_QUERY            = 280106;   //
// integer BOT_LOCATION                = 290232;   //
// integer BOT_SETUP_SETOPTIONS        = 280104;   //
integer BOT_SETUP_DEVICENAME        = 280103;      //
// integer BOT_SETUP_DEBUG             = 280105;   //
integer BOT_INSTANT_MESSAGE         = 280122;      //
// integer BOT_TELEPORT                = 280133;   //
integer BOT_SIT                     = 290214;      //
integer BOT_STAND                   = 290217;      //
integer BOT_LISTEN_MONEY_PAYMENTS   = 280142;      //
// integer BOT_GIVE_MONEY              = 280151;   //
// integer BOT_GIVE_MONEY_OBJECT       = 290225;   //
// integer BOT_GET_BALANCE             = 280152;   //
// integer BOT_WEAR                    = 280155;   //
// integer BOT_TAKEOFF                 = 290223;   //
// integer BOT_ATTACHMENTS             = 280153;   //
// integer BOT_LISTEN_DIALOG           = 280143;   //
// integer BOT_TOUCH_OBJECT            = 280148;   //
// integer BOT_ATTACHMENT_OBJECT       = 280149;   //
// integer BOT_DIALOG_REPLY            = 280154;   //
integer BOT_SETUP_SUCCESS           = 280201;      //
integer BOT_SETUP_FAILED            = 280202;      //
// integer BOT_COMMAND_FAILED          = 280203;   //
integer BOT_EVENT_LISTEN_MONEY      = 280207;      //
integer BOT_EVENT_LISTEN_SUCCESS    = 280208;      //
// integer BOT_GET_BALANCE_REPLY       = 280211;   //
// integer BOT_EVENT_LISTEN_DIALOG     = 280212;   //
/////////////////////////////////////////////////////
////////////////////////////////////////////////////
// Sit on Payment example
////////////////////////////////////////////////////
string deviceName = "Sit on Payment";
string botName = "Bot Name";
string botCode = "Bot Access Code";
string errorMessage = "You paid me the wrong amount!";
string sitObjectUUID = "UUID goes here";
integer paymentAmount = 5;

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
            // We added our bot fine
            llOwnerSay("Successfully setup bot: " + str);
            
            // Request listen to payments
            llMessageLinked(LINK_SET, BOT_LISTEN_MONEY_PAYMENTS, "", "");
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
        else if (num==BOT_EVENT_LISTEN_SUCCESS) {
            // We are ready!
            llOwnerSay("Sit on Payment Ready!");
        }
        else if (num==BOT_EVENT_LISTEN_MONEY) {
            // Woo we got paid! Check if they paid the right amount
            if ((integer)str >= paymentAmount) {
                llMessageLinked(LINK_SET, BOT_SIT, "", (key)sitObjectUUID);
            } else {
                llMessageLinked(LINK_SET, BOT_INSTANT_MESSAGE, errorMessage, id);
            }
        }
     }
}
