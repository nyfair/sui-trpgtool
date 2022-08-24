module trpg::item {
  use sui::url::{Self, Url};
  use sui::utf8;
  use sui::object::{Self, UID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};

  struct Item has key, store {
    id: UID,
    name: utf8::String,
    description: utf8::String,
    avatar: Url
  }

  public fun name(item: &Item): utf8::String {
    item.name
  }

  public fun description(item: &Item): utf8::String {
    item.description
  }

  public fun avatar(item: &Item): Url {
    item.avatar
  }

  public entry fun new_item(
    name: vector<u8>,
    description: vector<u8>,
    avatar: vector<u8>,
    ctx: &mut TxContext
  ) {
    let item = Item {
      id: object::new(ctx),
      name: utf8::string_unsafe(name),
      description: utf8::string_unsafe(description),
      avatar: url::new_unsafe_from_bytes(avatar)
    };
    let sender = tx_context::sender(ctx);
    transfer::transfer(item, sender);
  }
}