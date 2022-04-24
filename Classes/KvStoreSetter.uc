class KvStoreSetter extends Triggers;

#exec texture import file=Textures\ikvsetter.pcx name=i_ikvsetter group=Icons mips=Off flags=2

var() enum SetOperationType {
  SOT_SET,
  SOT_INCREMENT,
  SOT_DECREMENT,
} setOperation;

var() enum SetType {
  ST_LOCAL,
  ST_GLOBAL,
} setting;

var() bool ignoreCase;
var() localized String keyToSet;
var() localized String newValue;
var() bool dontOverwriteExisting;

function trigger(Actor other, Pawn eventInstigator) {
  local Inventory i;
  local KvStore kvs;
  local String value;
  local PlayerPawn p;
  local int intValue;

  if ((eventInstigator == none || PlayerPawn(eventInstigator) == none) && setting != ST_GLOBAL) return;

  if (eventInstigator != none && PlayerPawn(eventInstigator) != none) p = PlayerPawn(eventInstigator);

  if (p == none) {
    foreach allActors(class'PlayerPawn', p) {
      break;
    }
  }

  assert p != none;

  i = p.inventory;
  while (i != none) {
    if (KvStore(i) != none) {
      kvs = KvStore(i);
      break;
    }
    i = i.inventory;
  }
  
  if (kvs == none) {
    kvs = spawn(class'KvStore');
    kvs.touch(p);
  }

  assert kvs != none;

  switch(setOperation) {
    case SOT_SET:
      switch(setting) {
        case ST_LOCAL:
          value = kvs.get(keyToSet, true);
          if (value == "" || !dontOverwriteExisting) kvs.put(keyToSet, newValue, true);
          break;
        case ST_GLOBAL:
          value = kvs.get(keyToSet, false);
          if (value == "" || !dontOverwriteExisting) kvs.put(keyToSet, newValue, false);
          break;
      }
      break;
    case SOT_INCREMENT:
      switch(setting) {
        case ST_LOCAL:
          value = kvs.get(keyToSet, true);
          intValue = int(value);
          if (value == "") kvs.put(keyToSet, 1, true);
          else if (intValue == 0 && !dontOverwriteExisting) kvs.put(keyToSet, 1, true);
          else kvs.put(keyToSet, intValue + 1, true);
          break;
        case ST_GLOBAL:
          value = kvs.get(keyToSet, false);
          intValue = int(value);
          if (value == "") kvs.put(keyToSet, 1, false);
          else if (intValue == 0 && !dontOverwriteExisting) kvs.put(keyToSet, 1, false);
          else kvs.put(keyToSet, intValue + 1, false);
          break;
      }
      break;
    case SOT_DECREMENT:
      switch(setting) {
        case ST_LOCAL:
          value = kvs.get(keyToSet, true);
          intValue = int(value);
          if (value == "") kvs.put(keyToSet, -1, true);
          else if (intValue == 0 && !dontOverwriteExisting) kvs.put(keyToSet, -1, true);
          else kvs.put(keyToSet, intValue - 1, true);
          break;
        case ST_GLOBAL:
          value = kvs.get(keyToSet, false);
          intValue = int(value);
          if (value == "") kvs.put(keyToSet, -1, false);
          else if (intValue == 0 && !dontOverwriteExisting) kvs.put(keyToSet, -1, false);
          else kvs.put(keyToSet, intValue - 1, false);
          break;
      }
      break;
  }

  triggerEvent(event, self, eventInstigator);
}

defaultproperties {
  setting=ST_LOCAL
  setOperation=SOT_SET
  ignoreCase=true
  texture=Texture'i_ikvsetter'
}