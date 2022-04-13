class KvStoreChecker extends Triggers;

#exec texture import file=Textures\ikvcheck.pcx name=i_ikvchecker group=Icons mips=Off flags=2

var() enum CheckType {
  CT_LOCAL_ONLY,
  CT_GLOBAL_ONLY,
  CT_CASCADING,
} checking;

var() enum CheckActionType {
  CA_PRESENT,
  CA_NOT_PRESENT,
  CA_MATCH_VALUE,
  CA_GREATER,
  CA_GREATEREQUAL,
  CA_LESS,
  CA_LESSEQUAL,
} checkAction;

var() bool ignoreCase;
localized var() String keyToCheck;
localized var() String expectedValue;

var(Events) name eventOnCheckFailure;

function trigger(Actor other, Pawn eventInstigator) {
  local Inventory i;
  local KvStore kvs;
  local String value;
  local PlayerPawn playerPawn;

  if (PlayerPawn(eventInstigator) == none) return;
  i = PlayerPawn(eventInstigator).inventory;

  while (i != none) {
    if (KvStore(i) != none) break;
    i = i.inventory;
  }

  switch(checking) {
    case CT_LOCAL_ONLY:
      value = kvs.get(keyToCheck, true, ignoreCase);
      break;
    case CT_GLOBAL_ONLY:
      value = kvs.get(keyToCheck, true, ignoreCase);
      break;
    case CT_CASCADING:
      value = kvs.getCascading(keyToCheck, ignoreCase);
      break;
  }

  //todo
}

defaultproperties {
  checking=CT_CASCADING
  checkAction=CA_PRESENT
  ignoreCase=true
  texture=Texture'i_ikvchecker'
}