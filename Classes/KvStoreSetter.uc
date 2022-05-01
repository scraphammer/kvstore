//=============================================================================
// KvStoreSetter: Stores or modifies a key/value pair in the player(s) for later checking.
// Checking is performed by KvStoreChecker.
//=============================================================================
class KvStoreSetter extends Triggers;

#exec texture import file=Textures\ikvsetter.pcx name=i_ikvsetter group=Icons mips=Off flags=2

var() enum EOperationType {
  OT_SET,
  OT_INCREMENT,
  OT_DECREMENT,
} OperationType;

var() enum EOperationScope {
  OS_PERSONAL,
  OS_GLOBAL,
} OperationScope;

var() bool bIgnoreCase;
var() bool bOverwriteExisting;

var() localized String TargetKey;
var() localized String TargetValue;

function trigger(Actor other, Pawn eventInstigator) {
  local Inventory i;
  local KvStore kvs;
  local String value;
  local PlayerPawn p;
  local int intValue;

  if ((eventInstigator == none || PlayerPawn(eventInstigator) == none) && OperationScope != OS_GLOBAL) return;

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

  switch(OperationType) {
    case OT_SET:
      switch(OperationScope) {
        case OS_PERSONAL:
          value = kvs.get(TargetKey, true);
          if (value == "" || bOverwriteExisting) kvs.put(TargetKey, TargetValue, true);
          break;
        case OS_GLOBAL:
          value = kvs.get(TargetKey, false);
          if (value == "" || bOverwriteExisting) kvs.put(TargetKey, TargetValue, false);
          break;
      }
      break;
    case OT_INCREMENT:
      switch(OperationScope) {
        case OS_PERSONAL:
          value = kvs.get(TargetKey, true);
          intValue = int(value);
          if (value == "") kvs.put(TargetKey, 1, true);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(TargetKey, 1, true);
          else kvs.put(TargetKey, intValue + 1, true);
          break;
        case OS_GLOBAL:
          value = kvs.get(TargetKey, false);
          intValue = int(value);
          if (value == "") kvs.put(TargetKey, 1, false);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(TargetKey, 1, false);
          else kvs.put(TargetKey, intValue + 1, false);
          break;
      }
      break;
    case OT_DECREMENT:
      switch(OperationScope) {
        case OS_PERSONAL:
          value = kvs.get(TargetKey, true);
          intValue = int(value);
          if (value == "") kvs.put(TargetKey, -1, true);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(TargetKey, -1, true);
          else kvs.put(TargetKey, intValue - 1, true);
          break;
        case OS_GLOBAL:
          value = kvs.get(TargetKey, false);
          intValue = int(value);
          if (value == "") kvs.put(TargetKey, -1, false);
          else if (intValue == 0 && bOverwriteExisting) kvs.put(TargetKey, -1, false);
          else kvs.put(TargetKey, intValue - 1, false);
          break;
      }
      break;
  }

  triggerEvent(event, self, eventInstigator);
}

defaultproperties {
  OperationScope=OS_GLOBAL
  OperationType=OT_SET
  bIgnoreCase=True
  bOverwriteExisting=True
  Texture=Texture'i_ikvsetter'
}