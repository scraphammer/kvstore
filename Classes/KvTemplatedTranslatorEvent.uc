//=============================================================================
// KvTemplatedTranslatorEvent: when triggered or touched, replaces strings in its message with values from the instigator's KvStore.
// Also triggers its event when it is done, allowing for multiple events to be chainged together.
//=============================================================================
class KvTemplatedTranslatorEvent extends TranslatorEvent;

#exec texture import file=Textures\ikvtrans.pcx name=i_ikvtrans group=Icons mips=Off flags=2

enum ECheckScope {
  CS_CASCADING,
  CS_GLOBAL,
  CS_PERSONAL,
};

enum EReplacementOperation {
  OP_REPLACE, // replace text with key's stored value
  OP_PRESENT, // replace text with ReplaceWith if the logic is whatever
  OP_NOT_PRESENT,
  OP_EQUAL,
  OP_GREATER,
  OP_GREATEREQUAL,
  OP_LESS,
  OP_LESSEQUAL,
};

struct KvTemplatedTranslatorEventReplacement {
  var() localized string TargetKey;
  var() localized string DefaultReplacement;
  var() localized string ReplaceWith;
  var() localized string TargetValue;
  var() bool bIgnoreCase;
  var() localized EReplacementOperation ReplacementOperation;
  var() localized ECheckScope CheckScope;
};

var() KvTemplatedTranslatorEventReplacement Replacements[8];
var() localized string TemplateString;

static final operator(24) bool cge (coerce int a, coerce int b) {
  return a >= b;
}

static final operator(24) bool cg (coerce int a, coerce int b) {
  return a > b;
}

static final operator(24) bool cle (coerce int a, coerce int b) {
  return a <= b;
}

static final operator(24) bool cl (coerce int a, coerce int b) {
  return a < b;
}

static function string fmt(string input, string replace[8], string template) {
  local int i, j;
  local string output;
  i = inStr(input, template);
  while (i != -1 && j < 8) {
    output = output $ left(input, i) $ replace[j++];
    input = mid(input, i + Len(template));
		i = inStr(input, template);
  }
  output = output $ input;
  return output;
}

function trigger(Actor other, Pawn eventInstigator) {
  super.trigger(other, eventInstigator);
  if (event != '') triggerEvent(event, self, eventInstigator);
}

function string filterMessage(Actor other) {
  local PlayerPawn p;
  local Inventory inventory;
  local int i;
  local string replacedStrings[8];
  local KvStore kvs;
  local string value;

  if (other == none) return message;
  if (PlayerPawn(other) == none) return message;
  p = PlayerPawn(other);

  assert p != none;

  inventory = p.inventory;
  while (inventory != none) {
    if (KvStore(inventory) != none) {
      kvs = KvStore(inventory);
      break;
    }
    inventory = inventory.inventory;
  }
  
  if (kvs == none) {
    kvs = spawn(class'KvStore');
    kvs.touch(p);
  }

  assert kvs != none;

  for (i = 0; i < 8; i++) {
    switch(replacements[i].CheckScope) {
      case CS_PERSONAL:
        value = kvs.get(replacements[i].targetKey, true, replacements[i].bIgnoreCase);
        break;
      case CS_GLOBAL:
        value = kvs.get(replacements[i].targetKey, false, replacements[i].bIgnoreCase);
        break;
      case CS_CASCADING:
        value = kvs.getCascading(replacements[i].targetKey, replacements[i].bIgnoreCase);
        break;
    }

    switch(replacements[i].ReplacementOperation) {
      case OP_REPLACE:
        if (value != "") replacedStrings[i] = value;
        else replacedStrings[i] = replacements[i].defaultReplacement;
        break;
      case OP_PRESENT:
        if (value != "") replacedStrings[i] = replacements[i].replaceWith;
        else replacedStrings[i] = replacements[i].defaultReplacement;
        break;
      case OP_NOT_PRESENT:
        if (value != "") replacedStrings[i] = replacements[i].defaultReplacement;
        else replacedStrings[i] = replacements[i].replaceWith;
        break;
      case OP_EQUAL:
        if (value == replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
        else replacedStrings[i] = replacements[i].defaultReplacement;
        break;
      case OP_GREATER:
        if (class'KvStoreChecker'.static.canCoerceBoth(value, replacements[i].targetValue)) {
          if (value cg replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        } else {
          if (value > replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        }
        break;
      case OP_GREATEREQUAL:
        if (class'KvStoreChecker'.static.canCoerceBoth(value, replacements[i].targetValue)) {
          if (value cge replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        } else {
          if (value >= replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        }
        break;
      case OP_LESS:
        if (class'KvStoreChecker'.static.canCoerceBoth(value, replacements[i].targetValue)) {
          if (value cl replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        } else {
          if (value < replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        }
        break;
      case OP_LESSEQUAL:
        if (class'KvStoreChecker'.static.canCoerceBoth(value, replacements[i].targetValue)) {
          if (value cle replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        } else {
          if (value <= replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
        }
        break;
    }
  }
  
  return fmt(message, replacedStrings, templateString);
}

function touch(Actor other){
	local inventory Inv;

	if (PlayerPawn(Other) == none || bHitDelay) return;

	if ((Level.NetMode == NM_StandAlone && Hint == "" && Message == "") || Message == "") return;

	if (reTriggerDelay > 0) {
		if (Level.TimeSeconds - TriggerTime < ReTriggerDelay) return;
		TriggerTime = Level.TimeSeconds;
	}

	for (Inv = Other.Inventory; Inv != none; Inv = Inv.Inventory)
		if (Translator(Inv) != none) {
			Trans = Translator(Inv);
			Trans.Hint = hint;
			Trans.bShowHint = false;
			if (Message == "") {
				Trans.bNewMessage = true;
				Pawn(Other).ClientMessage(M_HintMessage);
				return;
			}
			if (!bHitOnce) Trans.bNewMessage = true;
			else Trans.bNotNewMessage = true;
			Trans.NewMessage = filterMessage(other);
			if (!bHitOnce) Pawn(Other).ClientMessage(M_NewMessage);
			else Pawn(Other).ClientMessage(M_TransMessage);
			bHitOnce = true;
			SetTimer(0.3,False);
			bHitDelay = true;
			PlaySound(NewMessageSound, SLOT_Misc);
			break;
		}
}

defaultproperties {
  TemplateString="%s";
  Texture=Texture'i_ikvtrans'
}