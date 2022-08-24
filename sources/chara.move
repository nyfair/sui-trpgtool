module trpg::chara {
  use sui::url::{Self, Url};
  use sui::utf8;
  use sui::object::{Self, ID, UID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};
  use sui::vec_map::{Self, VecMap};
  use trpg::item::Item;

  struct Character has key, store {
    id: UID,
    name: utf8::String,
    faction: u8,
    description: utf8::String,
    status: utf8::String,
    items: VecMap<ID, u64>,
    avatar: Url
  }

  public fun name(chara: &Character): utf8::String {
    chara.name
  }

  public fun faction(chara: &Character): u8 {
    chara.faction
  }

  public fun description(chara: &Character): utf8::String {
    chara.description
  }

  public fun status(chara: &Character): utf8::String {
    chara.status
  }

  public fun items(chara: &Character): VecMap<ID, u64> {
    chara.items
  }

  public fun avatar(chara: &Character): Url {
    chara.avatar
  }

  public entry fun new_chara(
    name: vector<u8>,
    faction: u8,
    description: vector<u8>,
    status: vector<u8>,
    avatar: vector<u8>,
    ctx: &mut TxContext
  ) {
    let chara = Character {
      id: object::new(ctx),
      name: utf8::string_unsafe(name),
      faction: faction,
      description: utf8::string_unsafe(description),
      status: utf8::string_unsafe(status),
      items: vec_map::empty(),
      avatar: url::new_unsafe_from_bytes(avatar)
    };
    let sender = tx_context::sender(ctx);
    transfer::transfer(chara, sender);
  }

  public entry fun update_chara(
    chara: &mut Character,
    name: vector<u8>,
    faction: u8,
    description: vector<u8>,
    avatar: vector<u8>
  ) {
    chara.name = utf8::string_unsafe(name);
    chara.faction = faction;
    chara.description = utf8::string_unsafe(description);
    chara.avatar = url::new_unsafe_from_bytes(avatar);
  }

  public entry fun update_status(
    chara: &mut Character,
    status: vector<u8>
  ) {
    chara.status = utf8::string_unsafe(status);
  }

  public entry fun add_item(
    chara: &mut Character,
    item: &Item,
    num: u64
  ) {
    let i = object::id(item);
    if (vec_map::contains(&chara.items, &i)) {
      let x = vec_map::get_mut(&mut chara.items, &i);
      *x = *x + num;
    } else {
      vec_map::insert(&mut chara.items, i, num);
    }
  }

  public entry fun burn_item(
    chara: &mut Character,
    item: &Item,
    num: u64
  ) {
    let i = object::id(item);
    if (vec_map::contains(&chara.items, &i)) {
      let x = vec_map::get_mut(&mut chara.items, &i);
      if (*x > num) {
        *x = *x - num;
      } else {
        if (*x == num) {
          vec_map::remove(&mut chara.items, &i);
        }
      }
    }
  }
}