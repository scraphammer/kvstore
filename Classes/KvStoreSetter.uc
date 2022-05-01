//=============================================================================
// KvStoreSetter: Stores or modifies a key/value pair in the player(s) for later checking.
// Checking is performed by KvStoreChecker.
// Also triggers its event when it is done, allowing for multiple events to be chainged together.
//=============================================================================
class KvStoreSetter extends Triggers;

#exec texture import file=Textures\ikvsetter.pcx name=i_ikvsetter group=Icons mips=Off flags=2

var(KvStore) enum EOperationType {
  OT_SET,
  OT_INCREMENT,
  OT_DECREMENT,
} OperationType;

var(KvStore) enum EOperationScope {
  OS_PERSONAL,
  OS_GLOBAL,
} OperationScope;

var(KvStore) bool bIgnoreCase;
var(KvStore) bool bOverwriteExisting;

var(KvStore) localized String TargetKey;
var(KvStore) localized String TargetValue;

function trigger(Actor other, Pawn eventInstigator) {
  local Inventory i;
  local KvStore kvs;
  local String value;
  local PlayerPawn p;
  local int intValue;
  local int newValueAsInt;

  if ((eventInstigator == none || PlayerPawn(eventInstigator) == none) && operationScope != OS_GLOBAL) return;

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

  switch(operationType) {
    case OT_SET:
      switch(operationScope) {
        case OS_PERSONAL:
          value = kvs.get(targetKey, true);
          if (value == "" || bOverwriteExisting) kvs.put(targetKey, targetValue, true);
          break;
        case OS_GLOBAL:
          value = kvs.get(TargetKey, false);
          if (value == "" || bOverwriteExisting) kvs.put(targetKey, targetValue, false);
          break;
      }
      break;
    case OT_INCREMENT:
      switch(operationScope) {
        case OS_PERSONAL:
          value = kvs.get(targetKey, true);
          intValue = int(value);
          if (targetValue != "" && int(targetValue) != 0) newValueAsInt = int(targetValue);
          else newValueAsInt = 1;
          if (value == "") kvs.put(targetKey, newValueAsInt, true);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(targetKey, newValueAsInt, true);
          else kvs.put(TargetKey, intValue + newValueAsInt, true);
          break;
        case OS_GLOBAL:
          value = kvs.get(targetKey, false);
          intValue = int(value);
          if (targetValue != "" && int(targetValue) != 0) newValueAsInt = int(targetValue);
          else newValueAsInt = 1;
          if (value == "") kvs.put(targetKey, newValueAsInt, false);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(TargetKey, newValueAsInt, false);
          else kvs.put(TargetKey, intValue + newValueAsInt, false);
          break;
      }
      break;
    case OT_DECREMENT:
      switch(operationScope) {
        case OS_PERSONAL:
          value = kvs.get(targetKey, true);
          intValue = int(value);
          if (targetValue != "" && int(targetValue) != 0) newValueAsInt = int(targetValue);
          else newValueAsInt = 1;
          if (value == "") kvs.put(targetKey, -newValueAsInt, true);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(targetKey, -newValueAsInt, true);
          else kvs.put(targetKey, intValue - newValueAsInt, true);
          break;
        case OS_GLOBAL:
          value = kvs.get(targetKey, false);
          intValue = int(value);
          if (targetValue != "" && int(targetValue) != 0) newValueAsInt = int(targetValue);
          else newValueAsInt = 1;
          if (value == "") kvs.put(targetKey, -newValueAsInt, false);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(targetKey, -newValueAsInt, false);
          else kvs.put(TargetKey, intValue - newValueAsInt, false);
          break;
      }
      break;
  }

  if (event != '') triggerEvent(event, self, eventInstigator);
}

defaultproperties {
  OperationScope=OS_GLOBAL
  OperationType=OT_SET
  bIgnoreCase=True
  bOverwriteExisting=True
  Texture=Texture'i_ikvsetter'
}