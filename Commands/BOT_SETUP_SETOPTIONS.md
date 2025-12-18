# BOT_SETUP_SETOPTIONS

Sets various options for LifeBots Control Panel.

```lsl
llMessageLinked(LINK_SET, BOT_SETUP_SETOPTIONS, "<options-list>", NULL_KEY);
```

## Variables

The following table shows input values (you send them with the API call) and returned output values.

| Variable | Required | Description               |
|:-------- |:-------- |:------------------------- |
| str      | yes      | options list, separated by commas. See the available options below. |
| id       | yes      | --                        |

## Available Options

The following options are currently available:

- `DATATYPE_JSON` - LifeBots Control Panel API calls return JSON format data (the default)
- `DATATYPE_URLENCODE` - LifeBots Control Panel API calls return URL encoded format data
- `NO_OWNERCHANGE_RESET` - LifeBots Control Panel does not reset itself on object owner change
- `OWNERCHANGE_RESET` - LifeBots Control Panel resets itself on object owner change (the default)

## Example

```lsl
integer BOT_SETUP_SETOPTIONS = 280104;

default
{
	state_entry()
	{
		llMessageLinked(LINK_SET, BOT_SETUP_SETOPTIONS, "NO_OWNERCHANGE_RESET", NULL_KEY);
	}
}
```
