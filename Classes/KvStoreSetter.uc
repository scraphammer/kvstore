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
  
}

defaultproperties {
  setting=ST_LOCAL
  setOperation=SOT_SET
  ignoreCase=true
  texture=Texture'i_ikvsetter'
}